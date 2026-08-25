import 'package:egypto/features/onboarding/screens/onboarding_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EgyptoApp extends StatelessWidget {
  const EgyptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 875),
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],      // locale: const Locale('ar'),
        home: const Scaffold(
          body: OnboardingScreen(),
        ),
      ),
    );
  }
}
