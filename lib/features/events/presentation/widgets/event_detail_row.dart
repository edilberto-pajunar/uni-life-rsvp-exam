import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';

/// A single labelled fact row: icon chip + label above value.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            icon,
            size: AppSizes.iconSizeSmall,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.smLg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelXS.copyWith(
                  color: AppColors.black.withValues(
                    alpha: AppSizes.opacityTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.xxs),
              Text(
                value,
                style: AppTypography.bodyM500.copyWith(color: AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
