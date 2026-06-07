import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';

/// "Spots filled" progress bar — mirrors the capacity bar on [EventCard].
class CapacityBar extends StatelessWidget {
  const CapacityBar({
    super.key,
    required this.rsvpCount,
    required this.capacity,
    required this.fillRatio,
  });

  final int rsvpCount;
  final int capacity;
  final double fillRatio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spots filled',
              style: AppTypography.labelXS.copyWith(
                color: AppColors.black.withValues(
                  alpha: AppSizes.opacityTextSecondary,
                ),
              ),
            ),
            Text(
              '$rsvpCount / $capacity',
              style: AppTypography.labelXS.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
          child: LinearProgressIndicator(
            value: fillRatio,
            minHeight: AppSizes.sm,
            backgroundColor: AppColors.grey,
            valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
          ),
        ),
      ],
    );
  }
}
