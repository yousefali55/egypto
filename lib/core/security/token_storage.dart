import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  final FlutterSecureStorage _storage;

  TokenStorage(this._storage);

  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      _log('Token write succeeded (access=true, refresh=true).');
    } catch (error) {
      _log('Token write failed (${error.runtimeType}).');
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: _accessTokenKey);
      _log('Access token read (present=${token?.isNotEmpty == true}).');
      return token;
    } catch (error) {
      _log('Access token read failed (${error.runtimeType}).');
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: _refreshTokenKey);
      _log('Refresh token read (present=${token?.isNotEmpty == true}).');
      return token;
    } catch (error) {
      _log('Refresh token read failed (${error.runtimeType}).');
      rethrow;
    }
  }

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      _log('Token delete succeeded (access=true, refresh=true).');
    } catch (error) {
      _log('Token delete failed (${error.runtimeType}).');
      rethrow;
    }
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[Auth] $message');
  }
}
