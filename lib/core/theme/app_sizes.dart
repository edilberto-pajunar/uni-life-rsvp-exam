import 'package:flutter/material.dart';

class AppSizes {
  // Spacing for (padding, margins)
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double smMd = 10.0;
  static const double smLg = 12.0;
  static const double md = 16.0;
  static const double mdLg = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double xxxxl = 56.0;
  static const double fiveXl = 70.0;

  // -- Border Radius --
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 10.0;
  static const double radiusSmLg = 14.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 32.0;

  // --- Checkbox Size ---
  static const double checkboxSize = 20.0;

  // --- Icon Sizes ---
  static const double iconSize2Xxl = xxl * 2; // 96
  static const double iconSizeXxl = xxl; // 48
  static const double iconSizeXl = xl; // 32
  static const double iconSizeLarge = lg + xs; // 28
  static const double iconSizeMedium = lg; // 24
  static const double iconSizeSmall = md + xs; // 20
  static const double iconSizeSmall2 = md + xxs; // 18
  static const double iconSizeSmall3 = md; // 16
  static const double iconSizeXs = sm + xs; // 12
  static const double iconSizeXxs = sm + xxs; // 10
  static const double iconSizeXxxs = xxs * 3; // 6
  static const double bottomNavFabSize = 62.0;

  // --- Opacity ---
  static const double opacityDisabled = 0.4;
  static const double opacityDisabledText = 0.6;
  static const double opacityBorder = 0.2;
  static const double opacityCard = 0.05;
  static const double opacityBorder2 = 0.1;
  static const double opacityTextSecondary = 0.7;
  static const double opacityHalf = 0.5;
  static const double opacityIcon = 0.15;

  // --- Card ---
  static const double cardHeight = 66.0;
  static const double cardWidth = 104.0;
  static const double cardContentWidth = 100.0;
  static const double cardtitleWidth = 315.0;
  static const double cardSubtitleWidth = 290;
  static const double cardTitleAppBarWidth = 170;

  // -- Aspect Ratio ---
  static const double aspectRatio2_5 = 2.3;
  static const double aspectRatio1_5 = 2.0;
  static const double aspectRatio3_0 = 3.0;

  // --- Page Padding ---
  static const defaultPadding = EdgeInsetsDirectional.only(
    start: AppSizes.md,
    end: AppSizes.md,
    top: AppSizes.xl,
    bottom: AppSizes.xl,
  );
}
