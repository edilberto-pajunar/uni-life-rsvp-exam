// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';

/// AppTypography
class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'Inter';
  static const String fontArimo = "Arimo";

  static TextStyle _t(double size, FontWeight weight, {Color? color}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  // -------- SEMANTIC (use these in widgets) --------
  static final TextStyle displayXl = _t40w800;
  static final TextStyle displayL = _t40w400;
  static final TextStyle displayM = _t36w600;
  static final TextStyle displayS = _t32w800;

  // Headline: section headers
  static final TextStyle headlineXxl = _t32w600;
  static final TextStyle headlineXl = _t30w700;
  static final TextStyle headlineL = _t30w600;
  static final TextStyle headlineM = _t28w700;
  static final TextStyle headlineS = _t28w600;

  // Title: subheaders / card titles
  static final TextStyle titleXL = _t26w700;
  static final TextStyle titleL = _t24w600;
  static final TextStyle titleM = _t22w600;
  static final TextStyle titleS = _t20w600;

  // Body: paragraph text
  static final TextStyle bodyXL = _t24w400;
  static final TextStyle bodyL = _t20w500;
  static final TextStyle bodyM = _t18w400;
  static final TextStyle bodyM500 = _t16w500;
  static final TextStyle bodyM600 = _t16w600;
  static final TextStyle bodyS = _t16w400;
  static final TextStyle bodyXS = _t14w400;
  static final TextStyle body2XS = _t12w400;
  static final TextStyle body3XS = _t10w400;
  static final TextStyle body4XS = _t8w400;

  // Label: buttons, chips, small emphasis
  static final TextStyle labelXL = _t22w700;
  static final TextStyle labelL = _t20w700;
  static final TextStyle labelM = _t16w700;
  static final TextStyle labelS = _t14w600;
  static final TextStyle labelXS = _t12w600;
  static final TextStyle label2XS = _t10w500;

  // Button: specific button typography styles
  static final TextStyle buttonLarge = _t18w600;
  static final TextStyle buttonMedium = _t16w400;
  static final TextStyle buttonSmall = _t14w500;
  static final TextStyle buttonXS = _t12w500;

  // -------- TOKENS (from Figma, exact size/weight) --------
  // Naming: t<size>w<weight>
  static final TextStyle _t8w400 = _t(8, FontWeight.w400);
  static final TextStyle _t10w400 = _t(10, FontWeight.w400);
  static final TextStyle _t10w500 = _t(10, FontWeight.w500);

  static final TextStyle _t12w400 = _t(
    12,
    FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle _t12w500 = _t(12, FontWeight.w500);
  static final TextStyle _t12w600 = _t(
    12,
    FontWeight.w600,
    color: AppColors.grey,
  );

  static final TextStyle _t14w400 = _t(
    14,
    FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle _t14w500 = _t(14, FontWeight.w500);
  static final TextStyle _t14w600 = _t(14, FontWeight.w600);

  static final TextStyle _t16w400 = _t(
    16,
    FontWeight.w400,
    color: AppColors.white,
  );
  static final TextStyle _t16w500 = _t(16, FontWeight.w500);
  static final TextStyle _t16w600 = _t(16, FontWeight.w600);
  static final TextStyle _t16w700 = _t(16, FontWeight.w700);

  static final TextStyle _t18w400 = _t(18, FontWeight.w400);
  static final TextStyle _t18w500 = _t(18, FontWeight.w500);
  static final TextStyle _t18w600 = _t(18, FontWeight.w600);

  static final TextStyle _t20w500 = _t(20, FontWeight.w500);
  static final TextStyle _t20w600 = _t(20, FontWeight.w600);
  static final TextStyle _t20w700 = _t(20, FontWeight.w700);

  static final TextStyle _t22w500 = _t(22, FontWeight.w500);
  static final TextStyle _t22w600 = _t(22, FontWeight.w600);
  static final TextStyle _t22w700 = _t(22, FontWeight.w700);

  static final TextStyle _t24w400 = _t(24, FontWeight.w400);
  static final TextStyle _t24w500 = _t(24, FontWeight.w500);
  static final TextStyle _t24w600 = _t(24, FontWeight.w600);

  static final TextStyle _t26w700 = _t(26, FontWeight.w700);

  static final TextStyle _t28w600 = _t(28, FontWeight.w600);
  static final TextStyle _t28w700 = _t(28, FontWeight.w700);

  static final TextStyle _t30w600 = _t(30, FontWeight.w600);
  static final TextStyle _t30w700 = _t(30, FontWeight.w700);

  static final TextStyle _t32w600 = _t(32, FontWeight.w600);
  static final TextStyle _t32w800 = _t(32, FontWeight.w800);

  static final TextStyle _t36w600 = _t(36, FontWeight.w600);

  static final TextStyle _t40w400 = _t(40, FontWeight.w400);
  static final TextStyle _t40w800 = _t(40, FontWeight.w800);

  static TextTheme toTextTheme({Color? color}) {
    final c = color;
    return TextTheme(
      displayLarge: displayXl.copyWith(color: c),
      displayMedium: displayL.copyWith(color: c),
      displaySmall: displayM.copyWith(color: c),

      headlineLarge: headlineXl.copyWith(color: c),
      headlineMedium: headlineL.copyWith(color: c),
      headlineSmall: headlineM.copyWith(color: c),

      titleLarge: titleXL.copyWith(color: c),
      titleMedium: titleL.copyWith(color: c),
      titleSmall: titleM.copyWith(color: c),

      bodyLarge: bodyL.copyWith(color: c),
      bodyMedium: bodyS.copyWith(color: c),
      bodySmall: bodyXS.copyWith(color: c),

      labelLarge: labelL.copyWith(color: c),
      labelMedium: labelS.copyWith(color: c),
      labelSmall: labelXS.copyWith(color: c),
    );
  }
}
