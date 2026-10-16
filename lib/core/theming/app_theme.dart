import 'package:egypto/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkGlow,
      brightness: Brightness.light,
      primary: AppColors.darkGlow,
      secondary: AppColors.darkGlow,
      surface: const Color(0xFFFFFFFF),
      surfaceContainerHighest: const Color(0xFFF3F5F8),
      onSurface: const Color(0xFF1B2430),
      onPrimary: const Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FB),
    textTheme: GoogleFonts.cairoTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF1B2430),
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkGlow,
      brightness: Brightness.dark,
      primary: AppColors.darkGlow,
      secondary: AppColors.darkGlow,
      surface: const Color(0xFF101820),
      surfaceContainerHighest: const Color(0xFF1B2733),
      onSurface: const Color(0xFFF3F6FA),
      onPrimary: const Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFF0E141A),
    textTheme: GoogleFonts.cairoTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFF3F6FA),
      elevation: 0,
    ),
  );
}
