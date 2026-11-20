import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/theming/app_theme.dart';
import 'package:egypto/features/my_account/data/repository/my_account_repo.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_image_picker.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_verification_cubit.dart';
import 'package:egypto/features/my_account/screens/identity_verification_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  testWidgets('supports Arabic RTL with the dark theme', (tester) async {
    final cubit = _createCubit();
    addTearDown(cubit.close);

    await _pumpScreen(tester, cubit, const Locale('ar'), AppTheme.darkTheme);

    expect(find.text('التحقق من الهوية'), findsOneWidget);
    expect(find.text('اختيار صورة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.rtl,
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );
  });

  testWidgets('supports English LTR with the light theme', (tester) async {
    final cubit = _createCubit();
    addTearDown(cubit.close);

    await _pumpScreen(tester, cubit, const Locale('en'), AppTheme.lightTheme);

    expect(find.text('Identity verification'), findsOneWidget);
    expect(find.text('Choose image'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.ltr,
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.light,
    );
  });

  testWidgets('rejected verification shows retry and opens the upload flow', (
    tester,
  ) async {
    final cubit = _createCubit();
    addTearDown(cubit.close);

    await _pumpScreen(
      tester,
      cubit,
      const Locale('en'),
      AppTheme.lightTheme,
      currentStatus: 'Rejected',
    );

    expect(
      find.text(
        'Your identity verification was rejected. You can try again by uploading your documents again.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    expect(find.text('Choose image'), findsOneWidget);
    await tester.tap(find.text('Choose image'));
    await tester.pumpAndSettle();
    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
  });

  testWidgets('pending and approved users cannot reopen identity upload', (
    tester,
  ) async {
    for (final status in ['Pending', 'Approved']) {
      final cubit = _createCubit();
      await _pumpScreen(
        tester,
        cubit,
        const Locale('en'),
        AppTheme.lightTheme,
        currentStatus: status,
      );

      expect(find.text('Try Again'), findsNothing);
      expect(find.text('Choose image'), findsNothing);
      expect(
        find.text(status == 'Pending' ? 'Under review' : 'Verified'),
        findsOneWidget,
      );
      await cubit.close();
    }
  });

  testWidgets('rejected retry message and action are localized in Arabic RTL', (
    tester,
  ) async {
    final cubit = _createCubit();
    addTearDown(cubit.close);

    await _pumpScreen(
      tester,
      cubit,
      const Locale('ar'),
      AppTheme.darkTheme,
      currentStatus: 'Rejected',
    );

    expect(
      find.text(
        'تم رفض التحقق من هويتك. يمكنك المحاولة مرة أخرى عن طريق رفع صور الهوية من جديد.',
      ),
      findsOneWidget,
    );
    expect(find.text('المحاولة مرة أخرى'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.rtl,
    );
  });
}

IdentityVerificationCubit _createCubit() {
  return IdentityVerificationCubit(
    MyAccountRepo(ApiService(Dio())),
    _EmptyImagePicker(),
  );
}

Future<void> _pumpScreen(
  WidgetTester tester,
  IdentityVerificationCubit cubit,
  Locale locale,
  ThemeData theme, {
  String? currentStatus,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        locale: locale,
        theme: theme,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: IdentityVerificationScreen(currentStatus: currentStatus),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _EmptyImagePicker implements IdentityImagePicker {
  @override
  Future<XFile?> pick({
    required IdentityImageSlot slot,
    required ImageSource source,
  }) async => null;
}
