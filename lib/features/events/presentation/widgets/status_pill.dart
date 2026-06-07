import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.isGoing});

  final bool isGoing;

  @override
  Widget build(BuildContext context) {
    final label = isGoing ? 'Going' : 'Open';
    final fg = isGoing ? AppColors.white : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.smMd,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: isGoing ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: AppColors.primary.withValues(
            alpha: isGoing ? 1.0 : AppSizes.opacityBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isGoing) ...[
            Icon(Icons.check_rounded, size: AppSizes.iconSizeXs, color: fg),
            const SizedBox(width: AppSizes.xs),
          ],
          Text(label, style: AppTypography.labelXS.copyWith(color: fg)),
        ],
      ),
    );
  }
}
