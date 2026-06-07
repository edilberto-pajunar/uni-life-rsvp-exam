import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_clickable.dart';

enum AppButtonVariant { primary, secondary, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.variant = AppButtonVariant.primary,
    required this.onPressed,
    required this.label,
    this.textColor = AppColors.white,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.disabled = false,
    this.color,
    this.textStyle,
    this.height,
    this.width,
    this.padding,
  });

  final AppButtonVariant variant;
  final VoidCallback onPressed;
  final String label;
  final Color textColor;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool disabled;
  final Color? color;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  factory AppButton.primary({
    required VoidCallback onPressed,
    required String label,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
    Color? color,
  }) {
    return AppButton(
      variant: AppButtonVariant.primary,
      onPressed: onPressed,
      label: label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      disabled: disabled,
      color: color,
    );
  }

  factory AppButton.secondary({
    required VoidCallback onPressed,
    required String label,
    Color textColor = AppColors.white,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return AppButton(
      variant: AppButtonVariant.secondary,
      onPressed: onPressed,
      label: label,
      textColor: textColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      disabled: disabled,
    );
  }

  factory AppButton.outlined({
    required VoidCallback onPressed,
    required String label,
    Color? borderColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return AppButton(
      variant: AppButtonVariant.outlined,
      onPressed: onPressed,
      label: label,
      textColor: AppColors.black,
      borderColor: borderColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      disabled: disabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final BoxDecoration decoration = switch (variant) {
      AppButtonVariant.primary => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: disabled ? AppColors.grey : color ?? AppColors.primary,
      ),
      AppButtonVariant.secondary => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: AppColors.white,
      ),
      AppButtonVariant.outlined => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: AppColors.white,
        border: Border.all(
          width: 1,
          color: disabled ? AppColors.grey : borderColor ?? AppColors.grey,
        ),
      ),
    };

    final borderRadius = BorderRadius.circular(AppSizes.md);
    return AppClickable(
      disabled: disabled,
      onPressed: onPressed,
      borderRadius: borderRadius,
      showSplash: !disabled,
      child: Container(
        // constraints: BoxConstraints(
        //   minHeight: height ?? 48,
        //   maxHeight: width ?? 48,
        // ),
        padding: padding ?? const EdgeInsets.all(AppSizes.md),
        decoration: decoration,
        alignment: Alignment.center,
        child: prefixIcon != null || suffixIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: AppSizes.sm),
                  ],
                  Text(
                    label,
                    style:
                        textStyle ??
                        theme.textTheme.bodyLarge?.copyWith(color: textColor),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: AppSizes.sm),
                    suffixIcon!,
                  ],
                ],
              )
            : Text(
                label,
                style:
                    textStyle ??
                    theme.textTheme.bodyLarge?.copyWith(color: textColor),
              ),
      ),
    );
  }
}
