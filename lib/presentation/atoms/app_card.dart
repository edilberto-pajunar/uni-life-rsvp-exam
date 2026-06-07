import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
  });

  final Widget child;
  final Color? color;
  final Color? borderColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  factory AppCard.outlined({
    required Widget child,
    Color? borderColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? color,
    double? width,
    double? height,
  }) {
    return AppCard(
      borderColor: borderColor,
      padding: padding,
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusLg),
      color: color ?? Colors.transparent,
      width: width,
      height: height,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color ?? AppColors.white.withValues(alpha: AppSizes.opacityCard),
        borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color:
              borderColor ??
              AppColors.white.withValues(alpha: AppSizes.opacityBorder),
        ),
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}
