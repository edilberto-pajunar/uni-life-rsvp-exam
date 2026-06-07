import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';

class AppTextTheme {
  static const String _fontFamily = 'Inter';

  static TextTheme get light => const TextTheme(
    displayLarge: TextStyle(fontFamily: _fontFamily),
    displayMedium: TextStyle(fontFamily: _fontFamily),
    displaySmall: TextStyle(fontFamily: _fontFamily),
    headlineLarge: TextStyle(fontFamily: _fontFamily),
    headlineMedium: TextStyle(fontFamily: _fontFamily),
    headlineSmall: TextStyle(fontFamily: _fontFamily),
    titleLarge: TextStyle(fontFamily: _fontFamily),
    titleMedium: TextStyle(fontFamily: _fontFamily),
    titleSmall: TextStyle(fontFamily: _fontFamily),
    bodyLarge: TextStyle(fontFamily: _fontFamily),
    bodyMedium: TextStyle(fontFamily: _fontFamily),
    bodySmall: TextStyle(fontFamily: _fontFamily),
    labelLarge: TextStyle(fontFamily: _fontFamily, fontSize: 16.0),
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(fontFamily: _fontFamily),
  );

  static TextTheme get dark => const TextTheme(
    displayLarge: TextStyle(fontFamily: _fontFamily),
    displayMedium: TextStyle(fontFamily: _fontFamily),
    displaySmall: TextStyle(fontFamily: _fontFamily),
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
    ),
    headlineMedium: TextStyle(fontFamily: _fontFamily),
    headlineSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24.0,
      color: AppColors.black,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(fontFamily: _fontFamily),
    titleMedium: TextStyle(fontFamily: _fontFamily),
    titleSmall: TextStyle(fontFamily: _fontFamily),
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.0,
      color: AppColors.black,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.0,
      color: AppColors.black,
    ),
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.0,
      color: AppColors.black,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(fontFamily: _fontFamily),
    labelSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12.0,
      color: AppColors.black,
      fontWeight: FontWeight.normal,
    ),
  );
}
