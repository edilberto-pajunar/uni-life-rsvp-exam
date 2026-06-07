import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_text_theme.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'Inter';

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    appBarTheme: const AppBarTheme(scrolledUnderElevation: 0, elevation: 0),

    // textTheme: AppTextTheme.light,
  );

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.background,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      textTheme: AppTextTheme.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: scheme.copyWith(),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0, elevation: 0),
      dividerColor: AppColors.grey,
    );
  }

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    textTheme: AppTextTheme.light,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(scrolledUnderElevation: 0, elevation: 0),
  );
}
