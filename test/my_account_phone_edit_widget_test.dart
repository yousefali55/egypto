import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/networking/auth_intercptors.dart';
import 'package:egypto/core/networking/dio_factory.dart';
import 'package:egypto/core/security/refresh_token_service.dart';
import 'package:egypto/core/security/token_storage.dart';
import 'package:egypto/core/theming/app_theme.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_image_picker.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_verification_cubit.dart';
import 'package:egypto/features/my_account/presentation/phone_number/edit_phone_cubit.dart';
import 'package:egypto/features/my_account/screens/my_account_screen.dart';
import 'package:egypto/features/my_account/screens/edit_phone_number_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  late _MemorySecureStorage secureStorage;
  late Map<String, dynamic> updateBody;
  late int profileRequests;
  var failProfileRefresh = false;

  setUp(() async {
    await getIt.reset();
    secureStorage = _MemorySecureStorage()
      ..values['accessToken'] = 'test-access'
      ..values['refreshToken'] = 'test-refresh';
    updateBody = {};
    profileRequests = 0;
    failProfileRefresh = false;

    final tokenStorage = TokenStorage(secureStorage);
    final refreshDio = DioFactory.createRefreshDio()
      ..httpClientAdapter = _CallbackAdapter((_) async => _response(500, {}));
    final refreshService = RefreshTokenService(
      apiService: ApiService(refreshDio),
      tokenStorage: tokenStorage,
    );
    final dio = DioFactory.createDio()
      ..httpClientAdapter = _CallbackAdapter((options) async {
        if (options.method == 'GET') {
          profileRequests++;
          if (profileRequests > 1 && failProfileRefresh) {
            return _response(503, {});
          }
          return _response(200, {
            'id': 'user-1',
            'firstName': profileRequests > 1 ? 'Updated' : 'Abdo',
            'lastName': 'Zikel',
            'email': 'abdo@example.test',
            'phone': '+201012345678',
          });
        }
        updateBody = Map<String, dynamic>.from(options.data as Map);
        return _response(200, {'phone': '+201112345678'});
      });
    final interceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      refreshTokenService: refreshService,
      dio: dio,
    );
    dio.interceptors.insert(0, interceptor);

    final repository = MyAccountRepo(ApiService(dio));
    getIt.registerFactory<MyAccountCubit>(
      () => MyAccountCubit(repository, tokenStorage, refreshService),
    );
    getIt.registerFactory<EditPhoneCubit>(() => EditPhoneCubit(repository));
    getIt.registerFactory<IdentityVerificationCubit>(
      () => IdentityVerificationCubit(repository, _TestIdentityImagePicker()),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'account phone row opens editor and updates after successful PUT',
    (tester) async {
      await tester.pumpWidget(_testApp(const MyAccountScreen()));
      await tester.pumpAndSettle();

      expect(find.text('+201012345678'), findsOneWidget);
      await tester.tap(find.text('+201012345678'));
      await tester.pumpAndSettle();

      expect(find.text('Edit phone number'), findsOneWidget);
      final phoneField = find.byType(TextFormField);
      await tester.enterText(phoneField, '020123');
      await tester.pump();
      expect(
        find.text('Enter a valid Egyptian mobile number.'),
        findsOneWidget,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      await tester.enterText(phoneField, '01112345678');
      await tester.pump();
      await tester.tap(find.text('Save phone number'));
      await tester.pumpAndSettle();

      expect(updateBody, {
        'firstName': 'Abdo',
        'lastName': 'Zikel',
        'phone': '+201112345678',
      });
      expect(find.text('+201112345678'), findsOneWidget);
      expect(find.text('Phone number updated successfully.'), findsOneWidget);
    },
  );

  testWidgets('edit screen uses Arabic copy and supports dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const _OpenEditPhoneScreen(),
        locale: const Locale('ar'),
        theme: AppTheme.darkTheme,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعديل رقم الهاتف'), findsOneWidget);
    expect(find.text('حفظ رقم الهاتف'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('identity verification row opens the capture flow', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const MyAccountScreen()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Identity verification'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Identity verification'));
    await tester.pumpAndSettle();

    expect(find.text('Selfie'), findsWidgets);
    await tester.tap(find.text('Choose image'));
    await tester.pumpAndSettle();
    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
  });

  testWidgets(
    'refresh indicator fetches the profile and updates the displayed data',
    (tester) async {
      await tester.pumpWidget(_testApp(const MyAccountScreen()));
      await tester.pumpAndSettle();
      expect(profileRequests, 1);
      expect(find.text('Abdo Zikel'), findsWidgets);
      final profileScrollView = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(RefreshIndicator),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      expect(profileScrollView.physics, isA<AlwaysScrollableScrollPhysics>());

      final refresh = tester
          .state<RefreshIndicatorState>(find.byType(RefreshIndicator))
          .show();
      await tester.pumpAndSettle();
      await refresh;

      expect(profileRequests, 2);
      expect(find.text('Updated Zikel'), findsWidgets);
      expect(find.text('Abdo Zikel'), findsNothing);
    },
  );

  testWidgets('failed refresh keeps profile visible and reports an error', (
    tester,
  ) async {
    failProfileRefresh = true;
    await tester.pumpWidget(_testApp(const MyAccountScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Abdo Zikel'), findsWidgets);

    final refresh = tester
        .state<RefreshIndicatorState>(find.byType(RefreshIndicator))
        .show();
    await tester.pumpAndSettle();
    await refresh;

    expect(profileRequests, 2);
    expect(find.text('Abdo Zikel'), findsWidgets);
    expect(
      find.text(
        "Couldn't refresh your profile. Check your connection and try again.",
      ),
      findsOneWidget,
    );
  });

}

Widget _testApp(
  Widget home, {
  Locale locale = const Locale('en'),
  ThemeData? theme,
}) {
  return ScreenUtilInit(
    designSize: const Size(428, 875),
    child: MaterialApp(
      locale: locale,
      theme: theme ?? AppTheme.lightTheme,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    ),
  );
}

class _OpenEditPhoneScreen extends StatelessWidget {
  const _OpenEditPhoneScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
          ..httpClientAdapter = _CallbackAdapter(
            (_) async => _response(200, {}),
          );
        return EditPhoneCubit(MyAccountRepo(ApiService(dio)));
      },
      child: const EditPhoneNumberScreen(),
    );
  }
}

class _TestIdentityImagePicker implements IdentityImagePicker {
  @override
  Future<XFile?> pick({
    required IdentityImageSlot slot,
    required ImageSource source,
  }) async => null;
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

ResponseBody _response(int statusCode, Object data) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
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
  }) async {
    return values[key];
  }
}
