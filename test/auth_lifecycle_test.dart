import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/networking/auth_intercptors.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/features/auth/login/data/repository/login_repo.dart';
import 'package:egypto/features/auth/login/persentation/cubit/login_cubit.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('successful login persists access and refresh tokens', () async {
    final storage = _MemorySecureStorage();
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
      ..httpClientAdapter = _CallbackAdapter((options) async {
        expect(options.uri.path, '/api/v1/auth/login');
        return _response(200, {
          'accessToken': 'login-access',
          'refreshToken': 'login-refresh',
        });
      });
    final cubit = LoginCubit(LoginRepo(ApiService(dio)), TokenStorage(storage))
      ..emailController.text = 'user@example.test'
      ..passwordController.text = 'test-password';

    await cubit.login();

    expect(cubit.state, isA<LoginSuccess>());
    final restoredStorage = TokenStorage(storage);
    expect(await restoredStorage.getAccessToken(), 'login-access');
    expect(await restoredStorage.getRefreshToken(), 'login-refresh');
    await cubit.close();
  });

  group('TokenStorage', () {
    test('writes both stable keys and reads them after recreation', () async {
      final secureStorage = _MemorySecureStorage();
      final loginStorage = TokenStorage(secureStorage);

      await loginStorage.saveToken(
        accessToken: 'access-before-restart',
        refreshToken: 'refresh-before-restart',
      );

      final restoredStorage = TokenStorage(secureStorage);
      expect(await restoredStorage.getAccessToken(), 'access-before-restart');
      expect(await restoredStorage.getRefreshToken(), 'refresh-before-restart');
      expect(
        secureStorage.values.keys,
        containsAll(['accessToken', 'refreshToken']),
      );
    });

    test('clears only the access and refresh credentials', () async {
      final secureStorage = _MemorySecureStorage();
      final tokenStorage = TokenStorage(secureStorage);
      await tokenStorage.saveToken(
        accessToken: 'access',
        refreshToken: 'refresh',
      );

      await tokenStorage.clearTokens();

      expect(secureStorage.values, isEmpty);
      expect(secureStorage.deletedKeys, ['accessToken', 'refreshToken']);
    });

    test(
      'explicit account logout clears credentials and marks guest state',
      () async {
        final storage = _MemorySecureStorage();
        final tokenStorage = TokenStorage(storage);
        await tokenStorage.saveToken(
          accessToken: 'access',
          refreshToken: 'refresh',
        );
        final accountCubit = MyAccountCubit(
          MyAccountRepo(ApiService(Dio())),
          tokenStorage,
          RefreshTokenService(
            apiService: ApiService(Dio()),
            tokenStorage: tokenStorage,
          ),
        );

        await accountCubit.logout();

        expect(accountCubit.state, isA<MyAccountUnauthenticated>());
        expect(await tokenStorage.getAccessToken(), isNull);
        expect(await tokenStorage.getRefreshToken(), isNull);
        await accountCubit.close();
      },
    );
  });

  group('Account session restoration', () {
    test(
      'restores stored credentials without requesting a profile at startup',
      () async {
        final storage = _MemorySecureStorage();
        final tokenStorage = TokenStorage(storage);
        await tokenStorage.saveToken(
          accessToken: 'restored-access',
          refreshToken: 'restored-refresh',
        );
        var profileRequests = 0;
        final profileDio =
            Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
              ..httpClientAdapter = _CallbackAdapter((_) async {
                profileRequests++;
                return _response(500, {});
              });
        final cubit = MyAccountCubit(
          MyAccountRepo(ApiService(profileDio)),
          tokenStorage,
          RefreshTokenService(
            apiService: ApiService(Dio()),
            tokenStorage: tokenStorage,
          ),
        );

        final firstRestore = cubit.restoreSession();
        final concurrentRestore = cubit.restoreSession();
        expect(identical(firstRestore, concurrentRestore), isTrue);
        expect(await firstRestore, isTrue);
        expect(cubit.state, isA<MyAccountSessionRestored>());
        expect(profileRequests, 0);
        expect(identical(cubit.restoreSession(), firstRestore), isTrue);
        expect(storage.readCounts, {'accessToken': 1, 'refreshToken': 1});
        await cubit.close();
      },
    );

    test('refreshes a missing access token during restoration', () async {
      final storage = _MemorySecureStorage()
        ..values['refreshToken'] = 'stored-refresh';
      final tokenStorage = TokenStorage(storage);
      var refreshRequests = 0;
      var profileRequests = 0;
      final profileDio =
          Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
            ..httpClientAdapter = _CallbackAdapter((_) async {
              profileRequests++;
              return _response(500, {});
            });
      final refreshDio =
          Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
            ..httpClientAdapter = _CallbackAdapter((_) async {
              refreshRequests++;
              return _response(200, {
                'accessToken': 'restored-access',
                'refreshToken': 'rotated-refresh',
              });
            });
      final cubit = MyAccountCubit(
        MyAccountRepo(ApiService(profileDio)),
        tokenStorage,
        RefreshTokenService(
          apiService: ApiService(refreshDio),
          tokenStorage: tokenStorage,
        ),
      );

      expect(await cubit.restoreSession(), isTrue);
      expect(cubit.state, isA<MyAccountSessionRestored>());
      expect(refreshRequests, 1);
      expect(profileRequests, 0);
      expect(await tokenStorage.getAccessToken(), 'restored-access');
      expect(await tokenStorage.getRefreshToken(), 'rotated-refresh');
      await cubit.close();
    });
  });

  group('AuthInterceptor lifecycle', () {
    test('refreshes, persists rotated credentials, and retries once', () async {
      final storage = _MemorySecureStorage();
      final tokenStorage = TokenStorage(storage);
      await tokenStorage.saveToken(
        accessToken: 'expired-access',
        refreshToken: 'refresh-one',
      );
      final capturedAuthorization = <Object?>[];
      RequestOptions? refreshRequest;
      var protectedRequests = 0;

      final dio = _createDio(
        tokenStorage: tokenStorage,
        protectedAdapter: _CallbackAdapter((options) async {
          capturedAuthorization.add(options.headers['Authorization']);
          protectedRequests++;
          return _response(
            protectedRequests == 1 ? 401 : 200,
            <String, dynamic>{'ok': true},
          );
        }),
        refreshAdapter: _CallbackAdapter((options) async {
          refreshRequest = options;
          return _response(200, {
            'accessToken': 'new-access',
            'refreshToken': 'refresh-two',
          });
        }),
      );

      final response = await dio.get<dynamic>('/profile');

      expect(response.statusCode, 200);
      expect(capturedAuthorization, [
        'Bearer expired-access',
        'Bearer new-access',
      ]);
      expect(refreshRequest!.uri.path, '/api/v1/auth/refresh');
      expect(refreshRequest!.data, {'refreshToken': 'refresh-one'});
      expect(await tokenStorage.getAccessToken(), 'new-access');
      expect(await tokenStorage.getRefreshToken(), 'refresh-two');
      expect(protectedRequests, 2);
    });

    test('clears credentials after the backend rejects refresh', () async {
      final storage = _MemorySecureStorage();
      final tokenStorage = TokenStorage(storage);
      await tokenStorage.saveToken(
        accessToken: 'expired-access',
        refreshToken: 'invalid-refresh',
      );
      var refreshRequests = 0;
      final dio = _createDio(
        tokenStorage: tokenStorage,
        protectedAdapter: _CallbackAdapter(
          (_) async => _response(401, {'message': 'unauthorized'}),
        ),
        refreshAdapter: _CallbackAdapter((_) async {
          refreshRequests++;
          return _response(401, {'message': 'invalid refresh token'});
        }),
      );

      await expectLater(
        dio.get<dynamic>('/profile'),
        throwsA(isA<DioException>()),
      );

      expect(refreshRequests, 1);
      expect(await tokenStorage.getAccessToken(), isNull);
      expect(await tokenStorage.getRefreshToken(), isNull);
    });

    test(
      'preserves credentials when refresh fails with a network error',
      () async {
        final storage = _MemorySecureStorage();
        final tokenStorage = TokenStorage(storage);
        await tokenStorage.saveToken(
          accessToken: 'expired-access',
          refreshToken: 'still-valid-refresh',
        );
        final dio = _createDio(
          tokenStorage: tokenStorage,
          protectedAdapter: _CallbackAdapter(
            (_) async => _response(401, {'message': 'unauthorized'}),
          ),
          refreshAdapter: _CallbackAdapter((options) async {
            throw DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
            );
          }),
        );

        await expectLater(
          dio.get<dynamic>('/profile'),
          throwsA(isA<DioException>()),
        );

        expect(await tokenStorage.getAccessToken(), 'expired-access');
        expect(await tokenStorage.getRefreshToken(), 'still-valid-refresh');
      },
    );

    test('does not loop when the retried request also returns 401', () async {
      final storage = _MemorySecureStorage();
      final tokenStorage = TokenStorage(storage);
      await tokenStorage.saveToken(
        accessToken: 'expired-access',
        refreshToken: 'refresh-one',
      );
      var protectedRequests = 0;
      final dio = _createDio(
        tokenStorage: tokenStorage,
        protectedAdapter: _CallbackAdapter((_) async {
          protectedRequests++;
          return _response(401, {'message': 'unauthorized'});
        }),
        refreshAdapter: _CallbackAdapter((_) async {
          return _response(200, {
            'accessToken': 'still-rejected-access',
            'refreshToken': 'refresh-two',
          });
        }),
      );

      await expectLater(
        dio.get<dynamic>('/profile'),
        throwsA(isA<DioException>()),
      );

      expect(protectedRequests, 2);
      expect(await tokenStorage.getAccessToken(), isNull);
      expect(await tokenStorage.getRefreshToken(), isNull);
    });

    test(
      'shares one refresh across concurrent unauthorized requests',
      () async {
        final storage = _MemorySecureStorage();
        final tokenStorage = TokenStorage(storage);
        await tokenStorage.saveToken(
          accessToken: 'expired-access',
          refreshToken: 'refresh-one',
        );
        final bothOriginalRequestsArrived = Completer<void>();
        var protectedRequests = 0;
        var refreshRequests = 0;
        final capturedAuthorization = <Object?>[];
        final dio = _createDio(
          tokenStorage: tokenStorage,
          protectedAdapter: _CallbackAdapter((options) async {
            protectedRequests++;
            capturedAuthorization.add(options.headers['Authorization']);
            if (protectedRequests <= 2) {
              if (protectedRequests == 2) {
                bothOriginalRequestsArrived.complete();
              }
              await bothOriginalRequestsArrived.future;
              return _response(401, {'message': 'expired'});
            }
            return _response(200, {'ok': true});
          }),
          refreshAdapter: _CallbackAdapter((_) async {
            refreshRequests++;
            await Future<void>.delayed(const Duration(milliseconds: 30));
            return _response(200, {
              'accessToken': 'new-access',
              'refreshToken': 'refresh-two',
            });
          }),
        );

        final responses = await Future.wait([
          dio.get<dynamic>('/first'),
          dio.get<dynamic>('/second'),
        ]);

        expect(responses.map((response) => response.statusCode), [200, 200]);
        expect(refreshRequests, 1);
        expect(protectedRequests, 4);
        expect(
          capturedAuthorization.where(
            (header) => header == 'Bearer new-access',
          ),
          hasLength(2),
        );
      },
    );

    test('does not authenticate public endpoints', () async {
      final storage = _MemorySecureStorage();
      final tokenStorage = TokenStorage(storage);
      await tokenStorage.saveToken(
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      Object? authorization;
      var refreshRequests = 0;
      final dio = _createDio(
        tokenStorage: tokenStorage,
        protectedAdapter: _CallbackAdapter((options) async {
          authorization = options.headers['Authorization'];
          return _response(401, {'message': 'unauthorized'});
        }),
        refreshAdapter: _CallbackAdapter((_) async {
          refreshRequests++;
          return _response(401, {});
        }),
      );

      await expectLater(
        dio.post<dynamic>('/auth/login'),
        throwsA(isA<DioException>()),
      );

      expect(authorization, isNull);
      expect(refreshRequests, 0);
      expect(await tokenStorage.getAccessToken(), 'access');
    });

    test('does not send credentials to external image hosts', () async {
      final storage = _MemorySecureStorage();
      final tokenStorage = TokenStorage(storage);
      await tokenStorage.saveToken(
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      Object? authorization;
      var refreshRequests = 0;
      final dio = _createDio(
        tokenStorage: tokenStorage,
        protectedAdapter: _CallbackAdapter((options) async {
          authorization = options.headers['Authorization'];
          return _response(401, {'message': 'unauthorized'});
        }),
        refreshAdapter: _CallbackAdapter((_) async {
          refreshRequests++;
          return _response(401, {});
        }),
      );

      await expectLater(
        dio.get<dynamic>('https://cdn.example.test/image.jpg'),
        throwsA(isA<DioException>()),
      );

      expect(authorization, isNull);
      expect(refreshRequests, 0);
      expect(await tokenStorage.getAccessToken(), 'access');
    });
  });
}

Dio _createDio({
  required TokenStorage tokenStorage,
  required HttpClientAdapter protectedAdapter,
  required HttpClientAdapter refreshAdapter,
}) {
  final refreshDio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
    ..httpClientAdapter = refreshAdapter;
  final refreshService = RefreshTokenService(
    apiService: ApiService(refreshDio),
    tokenStorage: tokenStorage,
  );
  final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
    ..httpClientAdapter = protectedAdapter;
  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      refreshTokenService: refreshService,
      dio: dio,
    ),
  );
  return dio;
}

ResponseBody _response(int statusCode, Map<String, dynamic> data) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

class _CallbackAdapter implements HttpClientAdapter {
  _CallbackAdapter(this.callback);

  final Future<ResponseBody> Function(RequestOptions options) callback;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return callback(options);
  }

  @override
  void close({bool force = false}) {}
}

class _MemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> values = {};
  final List<String> deletedKeys = [];
  final Map<String, int> readCounts = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    readCounts.update(key, (count) => count + 1, ifAbsent: () => 1);
    return values[key];
  }

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
    deletedKeys.add(key);
    values.remove(key);
  }
}
