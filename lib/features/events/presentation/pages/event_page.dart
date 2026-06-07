import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_life_rsvp_exam/core/constants/constant.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/extensions/datetime_extensions.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/capacity_bar.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/event_detail_row.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/rsvp_button.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/status_pill.dart';
import 'package:uni_life_rsvp_exam/features/events/providers/events_provider.dart';
import 'package:uni_life_rsvp_exam/features/home/data/models/app_user.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_card.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class EventPage extends ConsumerWidget {
  static const String routeName = 'event';
  const EventPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEvent = ref.watch(fetchEventProvider(eventId));

    ref.listen<AsyncValue<Event?>>(rsvpProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return AppScaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: asyncEvent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Text(
              'Failed to load event\n$error',
              textAlign: TextAlign.center,
              style: AppTypography.bodyS.copyWith(
                color: AppColors.black.withValues(
                  alpha: AppSizes.opacityTextSecondary,
                ),
              ),
            ),
          ),
        ),
        data: (event) => _EventBody(event: event),
      ),
    );
  }
}

class _EventBody extends ConsumerWidget {
  const _EventBody({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGoing = event.isRsvped ?? false;
    final fillRatio = () {
      final capacity = event.capacity ?? 0;
      if (capacity <= 0) return 0.0;
      return ((event.rsvpCount ?? 0) / capacity).clamp(0.0, 1.0);
    }();
    final attendees = event.attendees ?? const <AppUser>[];

    return ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                event.title ?? 'Untitled event',
                style: AppTypography.headlineM.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.xs),
              child: StatusPill(isGoing: isGoing),
            ),
          ],
        ),
        if ((event.description ?? '').isNotEmpty) ...[
          const SizedBox(height: AppSizes.smLg),
          Text(
            event.description!,
            style: AppTypography.bodyS.copyWith(
              color: AppColors.black.withValues(
                alpha: AppSizes.opacityTextSecondary,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSizes.lg),
        _DetailsCard(
          dateLabel: event.startTime?.toFormattedString() ?? 'Date TBA',
          location: event.location,
          rsvpCount: event.rsvpCount ?? 0,
          capacity: event.capacity ?? 0,
          fillRatio: fillRatio,
        ),
        const SizedBox(height: AppSizes.lg),
        _AttendeesSection(attendees: attendees),
        const SizedBox(height: AppSizes.md),
        RsvpButton(event: event),
        const SizedBox(height: AppSizes.md),
      ],
    );
  }
}

/// Card holding the key event facts (date, location, capacity) plus the
/// "spots filled" capacity bar.
class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.dateLabel,
    required this.location,
    required this.rsvpCount,
    required this.capacity,
    required this.fillRatio,
  });

  final String dateLabel;
  final String? location;
  final int rsvpCount;
  final int capacity;
  final double fillRatio;

  @override
  Widget build(BuildContext context) {
    final hasLocation = (location ?? '').isNotEmpty;

    return AppCard(
      color: AppColors.white,
      borderColor: AppColors.primary.withValues(alpha: AppSizes.opacityBorder2),
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date & time',
            value: dateLabel,
          ),
          const SizedBox(height: AppSizes.md),
          DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: hasLocation ? location! : 'Location TBA',
          ),
          const SizedBox(height: AppSizes.md),
          DetailRow(
            icon: Icons.people_outline,
            label: 'Capacity',
            value: '$rsvpCount / $capacity going',
          ),
          const SizedBox(height: AppSizes.mdLg),
          CapacityBar(
            rsvpCount: rsvpCount,
            capacity: capacity,
            fillRatio: fillRatio,
          ),
        ],
      ),
    );
  }
}

/// "Who's coming" header + the RSVP attendee list (or an empty state).
class _AttendeesSection extends StatelessWidget {
  const _AttendeesSection({required this.attendees});

  final List<AppUser> attendees;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Who's coming",
              style: AppTypography.titleS.copyWith(color: AppColors.black),
            ),
            const SizedBox(width: AppSizes.sm),
            _CountBadge(count: attendees.length),
          ],
        ),
        const SizedBox(height: AppSizes.smLg),
        if (attendees.isEmpty)
          const _EmptyAttendees()
        else
          AppCard(
            color: AppColors.white,
            borderColor: AppColors.primary.withValues(
              alpha: AppSizes.opacityBorder2,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            child: Column(
              children: [
                for (var i = 0; i < attendees.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: AppSizes.xs,
                      thickness: 1,
                      color: AppColors.black.withValues(
                        alpha: AppSizes.opacityBorder2,
                      ),
                    ),
                  _AttendeeTile(user: attendees[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Small rounded badge showing the attendee count.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: AppSizes.opacityIcon),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Text(
        '$count',
        style: AppTypography.labelXS.copyWith(color: AppColors.primary),
      ),
    );
  }
}

/// A single RSVP'd user: initials avatar + name + email.
class _AttendeeTile extends StatelessWidget {
  const _AttendeeTile({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final name = (user.name ?? '').trim();
    final displayName = name.isEmpty ? 'Unknown attendee' : name;
    final email = (user.email ?? '').trim();
    final isCurrentUser =
        user.id != null && user.id == AppConstant.currentUser.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.smLg),
      child: Row(
        children: [
          _InitialsAvatar(name: name),
          const SizedBox(width: AppSizes.smLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyM600.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: AppSizes.sm),
                      const _YouBadge(),
                    ],
                  ],
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.xxs),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyXS.copyWith(
                      color: AppColors.black.withValues(
                        alpha: AppSizes.opacityTextSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            size: AppSizes.iconSizeSmall,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

/// Small badge marking the attendee who is the current user.
class _YouBadge extends StatelessWidget {
  const _YouBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: AppSizes.opacityIcon),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Text(
        'You',
        style: AppTypography.labelXS.copyWith(color: AppColors.primary),
      ),
    );
  }
}

/// Circular avatar showing a user's initials over a primary fill.
class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.xxl,
      height: AppSizes.xxl,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials(name),
        style: AppTypography.labelS.copyWith(color: AppColors.white),
      ),
    );
  }
}

/// Empty state shown when nobody has RSVP'd yet.
class _EmptyAttendees extends StatelessWidget {
  const _EmptyAttendees();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white,
      borderColor: AppColors.primary.withValues(alpha: AppSizes.opacityBorder2),
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
      child: Column(
        children: [
          Icon(
            Icons.group_off_outlined,
            size: AppSizes.iconSizeXxl,
            color: AppColors.primary.withValues(alpha: AppSizes.opacityHalf),
          ),
          const SizedBox(height: AppSizes.smLg),
          Text(
            'No RSVPs yet',
            style: AppTypography.bodyM600.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: AppSizes.xxs),
          Text(
            'Be the first to reserve a spot.',
            style: AppTypography.bodyXS.copyWith(
              color: AppColors.black.withValues(
                alpha: AppSizes.opacityTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Initials from a name: first letter of the first two words, uppercased.
/// Falls back to "?" when no usable name is present.
String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return letters.isEmpty ? '?' : letters;
}
