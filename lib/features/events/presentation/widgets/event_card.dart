import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/pages/event_page.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_card.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_clickable.dart';

/// A polished, UI/UX-friendly card displaying a single RSVP [Event].
///
/// Visuals are built entirely from [AppColors] / [AppSizes] tokens so the card
/// stays consistent with the rest of the app. RSVP is static for now — the
/// button reflects [Event.isRsvped] but tapping is a no-op.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  bool get _isGoing => event.isRsvped ?? false;

  /// RSVP progress in the 0..1 range, guarded against null / zero capacity.
  double get _fillRatio {
    final capacity = event.capacity ?? 0;
    if (capacity <= 0) return 0;
    final count = event.rsvpCount ?? 0;
    return (count / capacity).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AppClickable(
      onPressed: () {
        context.pushNamed(EventPage.routeName, extra: {"event": event});
      },
      child: AppCard(
        color: AppColors.white,
        borderColor: AppColors.primary.withValues(
          alpha: AppSizes.opacityBorder2,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(title: event.title ?? 'Untitled event', isGoing: _isGoing),
            if ((event.description ?? '').isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              Text(
                event.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyXS.copyWith(
                  color: AppColors.black.withValues(
                    alpha: AppSizes.opacityTextSecondary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSizes.smLg),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                _MetaChip(
                  icon: Icons.calendar_today_outlined,
                  label: _formatDateTime(event.startTime),
                ),
                if ((event.location ?? '').isNotEmpty)
                  _MetaChip(
                    icon: Icons.location_on_outlined,
                    label: event.location!,
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.smLg),
            _CapacityBar(
              rsvpCount: event.rsvpCount ?? 0,
              capacity: event.capacity ?? 0,
              fillRatio: _fillRatio,
            ),
            const SizedBox(height: AppSizes.md),
            _RsvpButton(isGoing: _isGoing),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.isGoing});

  final String title;
  final bool isGoing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleS.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        _StatusPill(isGoing: isGoing),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isGoing});

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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

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

class _CapacityBar extends StatelessWidget {
  const _CapacityBar({
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

class _RsvpButton extends StatelessWidget {
  const _RsvpButton({required this.isGoing});

  final bool isGoing;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusMd);
    final label = isGoing ? 'Cancel RSVP' : 'RSVP';
    final fg = isGoing ? AppColors.primary : AppColors.white;

    return AppClickable(
      borderRadius: radius,
      onPressed: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.smMd),
        decoration: BoxDecoration(
          color: isGoing ? AppColors.white : AppColors.primary,
          borderRadius: radius,
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.labelM.copyWith(color: fg),
        ),
      ),
    );
  }
}

/// Compact, dependency-free date/time formatter, e.g. "Mon, Jun 7 · 3:05 PM".
String _formatDateTime(DateTime? dt) {
  if (dt == null) return 'Date TBA';

  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final weekday = weekdays[(dt.weekday - 1) % 7];
  final month = months[(dt.month - 1) % 12];

  final isPm = dt.hour >= 12;
  var hour12 = dt.hour % 12;
  if (hour12 == 0) hour12 = 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = isPm ? 'PM' : 'AM';

  return '$weekday, $month ${dt.day} · $hour12:$minute $period';
}
