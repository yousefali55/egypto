import 'package:dio/dio.dart';
import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/core/theming/app_theme.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:egypto/features/my_account/screens/my_account_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() async => getIt.reset());

  testWidgets('Guest activation updates account actions without relogin', (
    tester,
  ) async {
    final repository = _ProfileRepository();
    final storage = TokenStorage(_MemorySecureStorage());
    await storage.saveToken(accessToken: 'access', refreshToken: 'refresh');
    final cubit = MyAccountCubit(
      repository,
      storage,
      RefreshTokenService(apiService: ApiService(Dio()), tokenStorage: storage),
    );
    getIt.registerFactory<MyAccountCubit>(() => cubit);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Become a Host'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Become a Host'), findsOneWidget);
    expect(find.text('My properties'), findsNothing);

    await tester.tap(find.text('Become a Host'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Become a Host').last);
    await tester.pumpAndSettle();

    expect(repository.activationCalls, 1);
    expect(find.text('My properties'), findsOneWidget);
    expect(find.text('Become a Host'), findsNothing);
    expect(find.text('Your account is now a Host account.'), findsOneWidget);
  });
}

Widget _app() => ScreenUtilInit(
  designSize: const Size(390, 844),
  builder: (context, child) => MaterialApp(
    locale: const Locale('en'),
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: const MyAccountScreen(),
  ),
);

const _guest = UserProfileModel(
  firstName: 'Guest',
  lastName: 'User',
  email: 'guest@example.test',
);

const _host = UserProfileModel(
  firstName: 'Host',
  lastName: 'User',
  email: 'host@example.test',
  isHost: true,
);

class _ProfileRepository extends MyAccountRepo {
  _ProfileRepository() : super(ApiService(Dio()));

  int activationCalls = 0;

  @override
  Future<UserProfileModel> getProfile() async => _guest;

  @override
  Future<UserProfileModel> activateHost() async {
    activationCalls++;
    return _host;
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
