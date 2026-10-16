import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final RefreshTokenService _refreshTokenService;
  final Dio _dio;

  Future<bool>? _refreshFuture;

  static const String _retryKey = 'auth_retry';

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required RefreshTokenService refreshTokenService,
    required Dio dio,
  }) : _tokenStorage = tokenStorage,
       _refreshTokenService = refreshTokenService,
       _dio = dio;

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

    try {
      final latestToken = await _tokenStorage.getAccessToken();

      if (latestToken == null || latestToken.isEmpty) {
        handler.next(err);
        return;
      }

      final latestAuthorization = 'Bearer $latestToken';
      final requestAuthorization = request.headers['Authorization'];

      // لو الطلب اتعاد بالفعل ورجع 401،
      // ما نكررش محاولة الـ Refresh بلا نهاية.
      if (request.extra[_retryKey] == true) {
        if (requestAuthorization != latestAuthorization) {
          final response = await _retryRequest(request, latestToken);

          handler.resolve(response);
          return;
        }

        // التوكن الحالي اترفض حتى بعد إعادة الطلب.
        await _tokenStorage.clearTokens();
        handler.next(err);
        return;
      }

      // طلب آخر ممكن يكون جدّد التوكن بالفعل.
      // في الحالة دي نستخدم التوكن الأحدث بدل Refresh جديد.
      if (requestAuthorization != null &&
          requestAuthorization != latestAuthorization) {
        final response = await _retryRequest(request, latestToken);

        handler.resolve(response);
        return;
      }

      final refreshed = await _refreshOnce();

      if (!refreshed) {
        // Refresh Token مفقود أو مرفوض.
        await _tokenStorage.clearTokens();
        handler.next(err);
        return;
      }

      final newAccessToken = await _tokenStorage.getAccessToken();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _tokenStorage.clearTokens();
        handler.next(err);
        return;
      }

      final response = await _retryRequest(request, newAccessToken);

      handler.resolve(response);
    } on DioException {
      // خطأ شبكة أو سيرفر أثناء الـ Refresh أو إعادة الطلب.
      // لا نمسح التوكنات لمجرد حدوث خطأ مؤقت.
      handler.next(err);
    } catch (_) {
      // أخطاء أخرى: نحافظ على التوكنات أيضًا.
      handler.next(err);
    }
  }

  Future<bool> _refreshOnce() {
    final activeRefresh = _refreshFuture;

    if (activeRefresh != null) {
      return activeRefresh;
    }

    late final Future<bool> refresh;

    refresh = _refreshTokenService.refreshToken().whenComplete(() {
      if (identical(_refreshFuture, refresh)) {
        _refreshFuture = null;
      }
    });

    _refreshFuture = refresh;

    return refresh;
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions request,
    String accessToken,
  ) {
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.extra[_retryKey] = true;

    return _dio.fetch<dynamic>(request);
  }

  bool _isPublicEndpoint(RequestOptions options) {
    final path = _normalizePath(options.path);

    return path.endsWith(_normalizePath(ApiConstants.login)) ||
        path.endsWith(_normalizePath(ApiConstants.register)) ||
        path.endsWith(_normalizePath(ApiConstants.refresh));
  }

  String _normalizePath(String path) {
    final pathWithoutQuery = path.split('?').first;

    if (pathWithoutQuery.length > 1 && pathWithoutQuery.endsWith('/')) {
      return pathWithoutQuery.substring(0, pathWithoutQuery.length - 1);
    }

    return pathWithoutQuery;
  }
}
