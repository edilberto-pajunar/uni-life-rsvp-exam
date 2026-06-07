import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/extensions/datetime_extensions.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/pages/event_page.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/capacity_bar.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/rsvp_button.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/status_pill.dart';
import 'package:uni_life_rsvp_exam/features/events/providers/events_provider.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_card.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_chip.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_clickable.dart';

/// A polished, UI/UX-friendly card displaying a single RSVP [Event].
///
/// Visuals are built entirely from [AppColors] / [AppSizes] tokens so the card
/// stays consistent with the rest of the app. RSVP is static for now — the
/// button reflects [Event.isRsvped] but tapping is a no-op.
class EventCard extends ConsumerWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  /// RSVP progress in the 0..1 range, guarded against null / zero capacity.
  double get _fillRatio {
    final capacity = event.capacity ?? 0;
    if (capacity <= 0) return 0;
    final count = event.rsvpCount ?? 0;
    return (count / capacity).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Event?>>(rsvpProvider, (_, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return AppClickable(
      onPressed: () {
        context.pushNamed(EventPage.routeName, extra: {"eventId": event.id});
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    event.title ?? 'Untitled event',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleS.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                StatusPill(isGoing: event.isRsvped ?? false),
              ],
            ),
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
                AppChip(
                  icon: Icons.calendar_today_outlined,
                  label: event.startTime?.toFormattedString() ?? 'Date TBA',
                ),
                if ((event.location ?? '').isNotEmpty)
                  AppChip(
                    icon: Icons.location_on_outlined,
                    label: event.location!,
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.smLg),
            CapacityBar(
              rsvpCount: event.rsvpCount ?? 0,
              capacity: event.capacity ?? 0,
              fillRatio: _fillRatio,
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}
