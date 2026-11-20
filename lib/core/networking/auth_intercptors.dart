import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final RefreshTokenService _refreshTokenService;
  final Dio _dio;

  Future<bool>? _refreshFuture;

  static const String _retryKey = 'auth_retry';

  AuthInterceptor({
    required this._tokenStorage,
    required this._refreshTokenService,
    required this._dio,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (_isPublicEndpoint(options)) {
        handler.next(options);
        return;
      }

      final accessToken = await _tokenStorage.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 || _isPublicEndpoint(request)) {
      handler.next(err);
      return;
    }

    _log('Protected request returned HTTP 401.');

    try {
      final latestToken = await _tokenStorage.getAccessToken();

      if (latestToken == null || latestToken.isEmpty) {
        _log('Cannot refresh because the access token is missing.');
        handler.next(err);
        return;
      }

      final latestAuthorization = 'Bearer $latestToken';
      final requestAuthorization = request.headers['Authorization'];

      // لو الطلب اتعاد بالفعل ورجع 401، ما نكرر محاولة الـ Refresh بلا نهاية.
      if (request.extra[_retryKey] == true) {
        if (requestAuthorization == latestAuthorization) {
          await _tokenStorage.clearTokens();
          _log('Refreshed access token was rejected; session cleared.');
        } else {
          _log('Retried request used a stale token; newer session preserved.');
        }
        handler.next(err);
        return;
      }

      // طلب آخر ممكن يكون جدّد التوكن بالفعل.
      // في الحالة دي نستخدم التوكن الأحدث بدل Refresh جديد.
      if (requestAuthorization != null &&
          requestAuthorization != latestAuthorization) {
        _log('A newer access token is available; retrying without refresh.');
        final response = await _retryRequest(request, latestToken);

        handler.resolve(response);
        return;
      }

      final failedToken =
          _tokenFromAuthorization(requestAuthorization) ?? latestToken;
      final refreshed = await _refreshOnce(failedToken);

      if (!refreshed) {
        await _tokenStorage.clearTokens();
        _log('Refresh was definitively rejected; session cleared.');
        handler.next(err);
        return;
      }

      final newAccessToken = await _tokenStorage.getAccessToken();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        _log('Refresh completed without a readable access token.');
        handler.next(err);
        return;
      }

      _log('Retrying original request with the current access token.');
      final response = await _retryRequest(request, newAccessToken);

      handler.resolve(response);
    } on DioException catch (error) {
      _log('Refresh/retry failed (${_errorCategory(error)}).');
      handler.next(err);
    } catch (error) {
      _log('Refresh/retry failed (${error.runtimeType}).');
      handler.next(err);
    }
  }

  Future<bool> _refreshOnce(String failedToken) {
    final activeRefresh = _refreshFuture;

    if (activeRefresh != null) {
      _log('Joining in-flight refresh operation.');
      return activeRefresh;
    }

    late final Future<bool> refresh;

    refresh = _refreshIfNeeded(failedToken).whenComplete(() {
      if (identical(_refreshFuture, refresh)) {
        _refreshFuture = null;
      }
    });

    _refreshFuture = refresh;

    return refresh;
  }

  Future<bool> _refreshIfNeeded(String failedToken) async {
    final currentToken = await _tokenStorage.getAccessToken();
    if (currentToken != null &&
        currentToken.isNotEmpty &&
        currentToken != failedToken) {
      _log('Access token changed before refresh; reusing the newer token.');
      return true;
    }
    return _refreshTokenService.refreshToken();
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions request,
    String accessToken,
  ) {
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.extra[_retryKey] = true;

    return _dio.fetch<dynamic>(request);
  }

  String? _tokenFromAuthorization(Object? authorization) {
    if (authorization is! String || !authorization.startsWith('Bearer ')) {
      return null;
    }
    return authorization.substring('Bearer '.length);
  }

  bool _isPublicEndpoint(RequestOptions options) {
    if (options.uri.origin != Uri.parse(options.baseUrl).origin) return true;

    final path = _normalizePath(options.path);

    return path.endsWith(_normalizePath(ApiConstants.login)) ||
        path.endsWith(_normalizePath(ApiConstants.register)) ||
        path.endsWith(_normalizePath(ApiConstants.verifyOtp)) ||
        path.endsWith(_normalizePath(ApiConstants.resendOtp)) ||
        path.endsWith(_normalizePath(ApiConstants.refresh));
  }

  String _normalizePath(String path) {
    final pathWithoutQuery = path.split('?').first;

    if (pathWithoutQuery.length > 1 && pathWithoutQuery.endsWith('/')) {
      return pathWithoutQuery.substring(0, pathWithoutQuery.length - 1);
    }

    return pathWithoutQuery;
  }

  String _errorCategory(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) return 'HTTP $statusCode';
    return error.type.name;
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[Auth] $message');
  }
}
