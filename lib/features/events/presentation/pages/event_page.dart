import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/home/data/models/app_user.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_card.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

/// A detailed, UI/UX-friendly event screen.
///
/// Surfaces the full [Event] information alongside the list of users who
/// RSVP'd, so a viewer can see exactly who is attending. The visual language
/// mirrors [EventCard] and is built entirely from [AppColors] / [AppSizes] /
/// [AppTypography] tokens for consistency with the rest of the app.
class EventPage extends StatelessWidget {
  static const String routeName = 'event';
  const EventPage({super.key, required this.event});

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
    final attendees = event.attendees ?? const <AppUser>[];

    return AppScaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: ListView(
        children: [
          _HeroHeader(
            title: event.title ?? 'Untitled event',
            isGoing: _isGoing,
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
            dateLabel: _formatDateTime(event.startTime),
            location: event.location,
            rsvpCount: event.rsvpCount ?? 0,
            capacity: event.capacity ?? 0,
            fillRatio: _fillRatio,
          ),
          const SizedBox(height: AppSizes.lg),
          _AttendeesSection(attendees: attendees),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

/// Large title + going/open status pill, anchoring the top of the page.
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.title, required this.isGoing});

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
            style: AppTypography.headlineM.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.xs),
          child: _StatusPill(isGoing: isGoing),
        ),
      ],
    );
  }
}

/// Going / open pill — mirrors the status pill used on [EventCard].
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
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date & time',
            value: dateLabel,
          ),
          const SizedBox(height: AppSizes.md),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: hasLocation ? location! : 'Location TBA',
          ),
          const SizedBox(height: AppSizes.md),
          _DetailRow(
            icon: Icons.people_outline,
            label: 'Capacity',
            value: '$rsvpCount / $capacity going',
          ),
          const SizedBox(height: AppSizes.mdLg),
          _CapacityBar(
            rsvpCount: rsvpCount,
            capacity: capacity,
            fillRatio: fillRatio,
          ),
        ],
      ),
    );
  }
}

/// A single labelled fact row: icon chip + label above value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
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

/// "Spots filled" progress bar — mirrors the capacity bar on [EventCard].
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
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyM600.copyWith(
                    color: AppColors.black,
                  ),
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
