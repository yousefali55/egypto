import 'package:dio/dio.dart';
import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/navigation/floating_bottom_nav_bar.dart';
import 'package:egypto/core/navigation/screens/main_navigation_screen.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/core/theming/app_theme.dart';
import 'package:egypto/features/admin/data/models/admin_pending_page.dart';
import 'package:egypto/features/admin/data/repository/admin_repo.dart';
import 'package:egypto/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:egypto/features/home/data/models/search_properties_page.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/features/home/data/repository/home_properties_repo.dart';
import 'package:egypto/features/home/presentation/cubit/home_properties_cubit.dart';
import 'package:egypto/features/host_properties/data/models/create_property_request.dart';
import 'package:egypto/features/host_properties/data/repository/host_properties_repo.dart';
import 'package:egypto/features/host_properties/presentation/cubit/property_creation_cubit.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() async => getIt.reset());

  testWidgets('admin profile opens only the four Admin destinations', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(428, 875);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _registerDependencies(
      const UserProfileModel(
        id: 'admin-id',
        firstName: 'Admin',
        lastName: 'Account',
        email: 'admin@example.test',
        isAdmin: true,
      ),
    );

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final navigation = find.byType(FloatingBottomNavBar);
    for (final destination in [
      'Identity',
      'Pending Properties',
      'Add property',
      'Profile',
    ]) {
      expect(
        find.descendant(of: navigation, matching: find.text(destination)),
        findsOneWidget,
      );
    }
    expect(find.text('Home'), findsNothing);
    expect(find.text('Messages'), findsNothing);
    expect(find.text('Become a Host'), findsNothing);
    expect(find.text('My properties'), findsNothing);

    await tester.tap(
      find.descendant(
        of: navigation,
        matching: find.text('Pending Properties'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('There are no pending properties.'), findsOneWidget);
  });

  testWidgets('non-admin profile keeps the existing Guest navigation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(428, 875);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _registerDependencies(
      const UserProfileModel(
        id: 'guest-id',
        firstName: 'Guest',
        lastName: 'Account',
        email: 'guest@example.test',
      ),
    );

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final navigation = find.byType(FloatingBottomNavBar);
    for (final destination in ['Home', 'Messages', 'Explore', 'Account']) {
      expect(
        find.descendant(of: navigation, matching: find.text(destination)),
        findsOneWidget,
      );
    }
    expect(find.text('Identity'), findsNothing);
    expect(find.text('Pending Properties'), findsNothing);
  });

  testWidgets('Admin destinations follow Arabic RTL localization', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(428, 875);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _registerDependencies(
      const UserProfileModel(
        id: 'admin-id',
        firstName: 'Admin',
        lastName: 'Account',
        email: 'admin@example.test',
        isAdmin: true,
      ),
    );

    await tester.pumpWidget(_app(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    final identityLabel = find.text('الهوية');
    expect(identityLabel, findsOneWidget);
    expect(Directionality.of(tester.element(identityLabel)), TextDirection.rtl);
  });
}

Widget _app({Locale locale = const Locale('en')}) => ScreenUtilInit(
  designSize: const Size(428, 875),
  child: MaterialApp(
    locale: locale,
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: const MainNavigationScreen(),
  ),
);

Future<void> _registerDependencies(UserProfileModel profile) async {
  final tokenStorage = TokenStorage(_MemorySecureStorage());
  await tokenStorage.saveToken(accessToken: 'access', refreshToken: 'refresh');
  final profileRepository = _ProfileRepo(profile);
  final refreshService = RefreshTokenService(
    apiService: ApiService(Dio()),
    tokenStorage: tokenStorage,
  );
  getIt.registerFactory<MyAccountCubit>(
    () => MyAccountCubit(profileRepository, tokenStorage, refreshService),
  );
  getIt.registerFactory<HomePropertiesCubit>(
    () => HomePropertiesCubit(_HomeRepo()),
  );
  getIt.registerFactory<AdminCubit>(() => AdminCubit(_AdminRepo()));
  getIt.registerFactory<PropertyCreationCubit>(
    () => PropertyCreationCubit(_HostPropertiesRepo()),
  );
}

class _ProfileRepo extends MyAccountRepo {
  _ProfileRepo(this.profile) : super(ApiService(Dio()));

  final UserProfileModel profile;

  @override
  Future<UserProfileModel> getProfile() async => profile;
}

class _HomeRepo extends HomePropertiesRepo {
  _HomeRepo() : super(ApiService(Dio()));

  @override
  Future<SearchPropertiesPage> searchProperties({
    SearchPropertiesFilters filters = const SearchPropertiesFilters(),
  }) async => const SearchPropertiesPage(
    items: [],
    pageNumber: 1,
    totalPages: 0,
    totalCount: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );
}

class _AdminRepo extends AdminRepo {
  _AdminRepo() : super(ApiService(Dio()), Dio());

  @override
  Future<AdminPendingPage> getPendingIdentity({
    required int pageNumber,
    required int pageSize,
  }) async => _emptyPage;

  @override
  Future<AdminPendingPage> getPendingProperties({
    required int pageNumber,
    required int pageSize,
  }) async => _emptyPage;
}

class _HostPropertiesRepo extends HostPropertiesRepo {
  _HostPropertiesRepo() : super(ApiService(Dio()));

  @override
  Future<List<Amenity>> getAmenities() async => const [];
}

const _emptyPage = AdminPendingPage(
  items: [],
  pageNumber: 1,
  totalPages: 0,
  totalCount: 0,
  hasPreviousPage: false,
  hasNextPage: false,
);

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
