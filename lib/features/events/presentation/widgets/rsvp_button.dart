import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/providers/events_provider.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_button.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_loader.dart';

class RsvpButton extends ConsumerWidget {
  const RsvpButton({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rsvpState = ref.watch(rsvpProvider);
    final eventAsync = ref.watch(fetchEventProvider(event.id!));
    final isGoing = event.isRsvped ?? false;

    if (rsvpState.isLoading || eventAsync.isLoading) {
      return const AppLoader();
    }

    return isGoing
        ? AppButton.secondary(
            onPressed: () {},
            label: 'Confirmed',
            disabled: true,
            textColor: AppColors.success,
            prefixIcon: const Icon(
              Icons.check,
              color: AppColors.success,
              size: AppSizes.md,
            ),
          )
        : AppButton.primary(
            label: 'RSVP',
            onPressed: () async {
              await ref.read(rsvpProvider.notifier).toggleRsvp(event, !isGoing);
              ref.invalidate(fetchEventsProvider);
            },
          );
  }
}
