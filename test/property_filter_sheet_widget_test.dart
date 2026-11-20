import 'package:egypto/core/theming/app_theme.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/features/home/widgets/property_filter_sheet.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('incomplete date ranges cannot be applied in Arabic RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(428, 875),
        child: MaterialApp(
          locale: const Locale('ar'),
          theme: AppTheme.darkTheme,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: PropertyFilterSheet(
              initialFilters: SearchPropertiesFilters(
                checkIn: DateTime(2026, 11, 10),
              ),
              availableCities: const [],
            ),
          ),
        ),
      ),
    );

    expect(
      Directionality.of(tester.element(find.text('الفلاتر'))),
      TextDirection.rtl,
    );
    await tester.tap(find.text('تطبيق الفلاتر'));
    await tester.pump();

    expect(find.text('اختر تاريخي تسجيل الوصول والمغادرة.'), findsOneWidget);
  });
}
