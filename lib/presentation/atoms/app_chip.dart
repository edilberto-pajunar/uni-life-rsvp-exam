import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';

class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconSizeSmall3, color: AppColors.primary),
          const SizedBox(width: AppSizes.xs),
          Text(
            label,
            style: AppTypography.bodyXS.copyWith(color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
