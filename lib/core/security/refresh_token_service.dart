import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/security/models/refresh_request_model.dart';
import 'package:egypto/core/security/token_storage.dart';

class RefreshTokenService {
  final ApiService _apiService;
  final TokenStorage _tokenStorage;

  RefreshTokenService({
    required ApiService apiService,
    required TokenStorage tokenStorage,
  })  : _apiService = apiService,
        _tokenStorage = tokenStorage;

  Future<bool> refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _apiService.refreshToken(
        RefreshRequestModel(refreshToken: refreshToken),
      );

      if (response.accessToken.isEmpty ||
          response.refreshToken.isEmpty) {
        return false;
      }

      await _tokenStorage.saveToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return true;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;

      // السيرفر رفض الـ Refresh Token؛ الجلسة لم تعد صالحة.
      if (statusCode == 401 || statusCode == 403) {
        return false;
      }

      // خطأ اتصال أو سيرفر: مش دليل إن الجلسة انتهت.
      rethrow;
    }
  }
}
