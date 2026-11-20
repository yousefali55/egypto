import 'dart:async';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'activation refreshes the profile and prevents duplicate requests',
    () async {
      final repository = _ActivationRepo();
      final cubit = await _createCubit(repository);
      addTearDown(cubit.close);

      expect((cubit.state as MyAccountLoaded).profile.isHost, isFalse);
      final activation = cubit.activateHost();
      expect((cubit.state as MyAccountLoaded).isActivatingHost, isTrue);
      expect(await cubit.activateHost(), isFalse);
      expect(repository.activationCalls, 1);

      repository.activation.complete(_hostProfile);
      expect(await activation, isTrue);
      expect((cubit.state as MyAccountLoaded).profile.isHost, isTrue);
    },
  );

  test('failed activation leaves the account as Guest', () async {
    final repository = _ActivationRepo()..failActivation = true;
    final cubit = await _createCubit(repository);
    addTearDown(cubit.close);

    expect(await cubit.activateHost(), isFalse);
    expect((cubit.state as MyAccountLoaded).profile.isHost, isFalse);
    expect(repository.activationCalls, 1);
  });
}

Future<MyAccountCubit> _createCubit(_ActivationRepo repository) async {
  final storage = TokenStorage(_MemorySecureStorage());
  await storage.saveToken(accessToken: 'access', refreshToken: 'refresh');
  final apiService = ApiService(Dio());
  final cubit = MyAccountCubit(
    repository,
    storage,
    RefreshTokenService(apiService: apiService, tokenStorage: storage),
  );
  await cubit.loadProfile();
  return cubit;
}

const _guestProfile = UserProfileModel(
  firstName: 'Guest',
  lastName: 'User',
  email: 'guest@example.test',
);

const _hostProfile = UserProfileModel(
  firstName: 'Host',
  lastName: 'User',
  email: 'host@example.test',
  isHost: true,
);

class _ActivationRepo extends MyAccountRepo {
  _ActivationRepo() : super(ApiService(Dio()));

  final Completer<UserProfileModel> activation = Completer<UserProfileModel>();
  int activationCalls = 0;
  bool failActivation = false;

  @override
  Future<UserProfileModel> getProfile() async => _guestProfile;

  @override
  Future<UserProfileModel> activateHost() async {
    activationCalls++;
    if (failActivation) {
      throw const AppException(
        errorType: AppErrorType.forbidden,
        message: 'Forbidden',
      );
    }
    return activation.future;
  }
}

class _MemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> _values = {};

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
      _values.remove(key);
    } else {
      _values[key] = value;
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
  }) async => _values[key];

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
    _values.remove(key);
  }
}
