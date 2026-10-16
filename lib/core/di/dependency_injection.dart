import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/networking/auth_intercptors.dart';
import 'package:egypto/core/networking/dio_factory.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';

import 'package:egypto/features/auth/login/data/repository/login_repo.dart';
import 'package:egypto/features/auth/login/persentation/cubit/login_cubit.dart';
import 'package:egypto/features/auth/register/data/repo/register_repo.dart';
import 'package:egypto/features/auth/register/persentation/cubit/register_cubit.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Token Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<TokenStorage>(
    () => TokenStorage(getIt<FlutterSecureStorage>()),
  );

  // Refresh API - Dio منفصل بدون AuthInterceptor
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(DioFactory.createRefreshDio()),
    instanceName: 'refresh',
  );

  // Refresh Token Service
  getIt.registerLazySingleton<RefreshTokenService>(
    () => RefreshTokenService(
      apiService: getIt<ApiService>(instanceName: 'refresh'),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // Main Dio
  final mainDio = DioFactory.createDio();

  // Auth Interceptor
  final authInterceptor = AuthInterceptor(
    tokenStorage: getIt<TokenStorage>(),
    refreshTokenService: getIt<RefreshTokenService>(),
    dio: mainDio,
  );

  mainDio.interceptors.add(authInterceptor);

  getIt.registerSingleton<Dio>(mainDio);

  // Main API Service
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  // Login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt<ApiService>()));

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginRepo>(), getIt<TokenStorage>()),
  );

  // Register
  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepo(getIt<ApiService>()),
  );

  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<RegisterRepo>()),
  );

  getIt.registerLazySingleton<MyAccountRepo>(
    () => MyAccountRepo(getIt<ApiService>()),
  );

  getIt.registerFactory<MyAccountCubit>(
    () => MyAccountCubit(getIt<MyAccountRepo>(), getIt<TokenStorage>()),
  );
}
