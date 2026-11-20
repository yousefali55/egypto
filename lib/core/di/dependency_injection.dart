import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/networking/auth_intercptors.dart';
import 'package:egypto/core/networking/dio_factory.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';

import 'package:egypto/features/auth/login/data/repository/login_repo.dart';
import 'package:egypto/features/auth/login/persentation/cubit/login_cubit.dart';
import 'package:egypto/features/auth/otp/data/repository/otp_repo.dart';
import 'package:egypto/features/auth/otp/persentaion/cubit/otp_cubit.dart';
import 'package:egypto/features/auth/register/data/repo/register_repo.dart';
import 'package:egypto/features/auth/register/persentation/cubit/register_cubit.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:egypto/features/my_account/presentation/phone_number/edit_phone_cubit.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_image_picker.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_verification_cubit.dart';
import 'package:egypto/features/host_properties/data/repository/host_properties_repo.dart';
import 'package:egypto/features/host_properties/presentation/cubit/host_properties_cubit.dart';
import 'package:egypto/features/host_properties/presentation/cubit/property_creation_cubit.dart';
import 'package:egypto/features/home/data/repository/home_properties_repo.dart';
import 'package:egypto/features/home/presentation/cubit/home_properties_cubit.dart';
import 'package:egypto/features/admin/data/repository/admin_repo.dart';
import 'package:egypto/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:egypto/features/bookings/data/repository/booking_repository.dart';
import 'package:egypto/features/bookings/presentation/cubit/guest_booking_cubit.dart';
import 'package:egypto/features/bookings/presentation/cubit/host_bookings_cubit.dart';

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

  getIt.registerLazySingleton<OtpRepo>(() => OtpRepo(getIt<ApiService>()));

  getIt.registerFactoryParam<OtpCubit, String, void>(
    (email, _) => OtpCubit(otpRepo: getIt<OtpRepo>(), email: email),
  );

  getIt.registerLazySingleton<MyAccountRepo>(
    () => MyAccountRepo(getIt<ApiService>()),
  );

  getIt.registerFactory<MyAccountCubit>(
    () => MyAccountCubit(
      getIt<MyAccountRepo>(),
      getIt<TokenStorage>(),
      getIt<RefreshTokenService>(),
    ),
  );

  getIt.registerFactory<EditPhoneCubit>(
    () => EditPhoneCubit(getIt<MyAccountRepo>()),
  );

  getIt.registerFactory<IdentityImagePicker>(() => DeviceIdentityImagePicker());
  getIt.registerFactory<IdentityVerificationCubit>(
    () => IdentityVerificationCubit(
      getIt<MyAccountRepo>(),
      getIt<IdentityImagePicker>(),
    ),
  );

  getIt.registerLazySingleton<HostPropertiesRepo>(
    () => HostPropertiesRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<HostPropertiesCubit>(
    () => HostPropertiesCubit(getIt<HostPropertiesRepo>()),
  );
  getIt.registerFactory<PropertyCreationCubit>(
    () => PropertyCreationCubit(getIt<HostPropertiesRepo>()),
  );
  getIt.registerLazySingleton<HomePropertiesRepo>(
    () => HomePropertiesRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<HomePropertiesCubit>(
    () => HomePropertiesCubit(getIt<HomePropertiesRepo>()),
  );

  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepository(getIt<ApiService>()),
  );
  getIt.registerFactory<GuestBookingCubit>(
    () => GuestBookingCubit(getIt<BookingRepository>()),
  );
  getIt.registerFactory<GuestBookingsCubit>(
    () => GuestBookingsCubit(getIt<BookingRepository>()),
  );
  getIt.registerFactory<BookingDetailsCubit>(
    () => BookingDetailsCubit(getIt<BookingRepository>()),
  );
  getIt.registerFactory<HostBookingsCubit>(
    () => HostBookingsCubit(getIt<BookingRepository>()),
  );

  getIt.registerLazySingleton<AdminRepo>(
    () => AdminRepo(getIt<ApiService>(), getIt<Dio>()),
  );
  getIt.registerFactory<AdminCubit>(() => AdminCubit(getIt<AdminRepo>()));
}
