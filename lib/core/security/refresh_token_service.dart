import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/security/models/refresh_request_model.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:flutter/foundation.dart';

class RefreshTokenService {
  final ApiService _apiService;
  final TokenStorage _tokenStorage;

  RefreshTokenService({
    required ApiService apiService,
    required TokenStorage tokenStorage,
  })  : _apiService = apiService,
        _tokenStorage = tokenStorage;

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _log('Refresh unavailable (refresh token missing).');
        return false;
      }

      _log('Refresh attempt started.');
      final response = await _apiService.refreshToken(
        RefreshRequestModel(refreshToken: refreshToken),
      );

      if (response.accessToken.isEmpty ||
          response.refreshToken.isEmpty) {
        throw const FormatException('Refresh response contains empty tokens.');
      }

      await _tokenStorage.saveToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      _log('Refresh succeeded; returned credentials were persisted.');
      return true;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 401 || statusCode == 403) {
        _log('Refresh rejected with HTTP $statusCode.');
        return false;
      }

      _log('Refresh failed temporarily (${_errorCategory(error)}).');
      rethrow;
    } on FormatException catch (error) {
      _log('Refresh response was invalid (${error.runtimeType}).');
      rethrow;
    } catch (error) {
      _log('Refresh failed (${error.runtimeType}).');
      rethrow;
    }
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
