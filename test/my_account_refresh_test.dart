import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'coalesces repeated refresh calls and updates the profile once',
    () async {
      final storage = _MemorySecureStorage()
        ..values['accessToken'] = 'access'
        ..values['refreshToken'] = 'refresh';
      final refreshGate = Completer<void>();
      final refreshStarted = Completer<void>();
      var profileRequests = 0;
      final profileDio =
          Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
            ..httpClientAdapter = _CallbackAdapter((_) async {
              profileRequests++;
              if (profileRequests > 1) {
                refreshStarted.complete();
                await refreshGate.future;
              }
              return _profileResponse(
                profileRequests > 1 ? 'Latest' : 'Initial',
              );
            });
      final tokenStorage = TokenStorage(storage);
      final cubit = MyAccountCubit(
        MyAccountRepo(ApiService(profileDio)),
        tokenStorage,
        RefreshTokenService(
          apiService: ApiService(Dio()),
          tokenStorage: tokenStorage,
        ),
      );
      addTearDown(cubit.close);

      await cubit.loadProfile();
      expect(cubit.state, isA<MyAccountLoaded>());
      final initialProfileState = cubit.state;
      final firstRefresh = cubit.refreshProfile();
      final repeatedRefresh = cubit.refreshProfile();
      expect(identical(firstRefresh, repeatedRefresh), isTrue);
      await refreshStarted.future;
      expect(profileRequests, 2);
      expect(identical(cubit.state, initialProfileState), isTrue);
      refreshGate.complete();
      expect(await firstRefresh, isTrue);
      expect(profileRequests, 2);
      expect((cubit.state as MyAccountLoaded).profile.firstName, 'Latest');
    },
  );

  test(
    'refresh failure keeps profile and credentials without logging out',
    () async {
      final storage = _MemorySecureStorage()
        ..values['accessToken'] = 'access'
        ..values['refreshToken'] = 'refresh';
      var profileRequests = 0;
      final profileDio =
          Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
            ..httpClientAdapter = _CallbackAdapter((_) async {
              profileRequests++;
              return profileRequests == 1
                  ? _profileResponse('Still here')
                  : _response(503, {});
            });
      final tokenStorage = TokenStorage(storage);
      final cubit = MyAccountCubit(
        MyAccountRepo(ApiService(profileDio)),
        tokenStorage,
        RefreshTokenService(
          apiService: ApiService(Dio()),
          tokenStorage: tokenStorage,
        ),
      );
      addTearDown(cubit.close);

      await cubit.loadProfile();
      final initialState = cubit.state as MyAccountLoaded;
      expect(await cubit.refreshProfile(), isFalse);

      expect(identical(cubit.state, initialState), isTrue);
      expect(await tokenStorage.getAccessToken(), 'access');
      expect(await tokenStorage.getRefreshToken(), 'refresh');
    },
  );
}

ResponseBody _profileResponse(String firstName) => _response(200, {
  'id': 'user-1',
  'firstName': firstName,
  'lastName': 'Tester',
  'email': 'user@example.test',
});

ResponseBody _response(int status, Object data) => ResponseBody.fromString(
  jsonEncode(data),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

class _CallbackAdapter implements HttpClientAdapter {
  _CallbackAdapter(this.callback);

  final Future<ResponseBody> Function(RequestOptions) callback;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => callback(options);

  @override
  void close({bool force = false}) {}
}

class _MemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values[key];

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }
}
