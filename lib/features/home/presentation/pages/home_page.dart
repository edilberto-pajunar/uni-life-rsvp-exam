import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/login_page.dart';
import 'package:uni_life_rsvp_exam/features/auth/providers/auth_provider.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/event_card.dart';
import 'package:uni_life_rsvp_exam/features/events/providers/events_provider.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_loader.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final authNotifier = ref.read(authProvider.notifier);
              return IconButton(
                onPressed: () async {
                  await authNotifier.signOut();
                  if (context.mounted) {
                    context.goNamed(LoginPage.routeName);
                  }
                },
                icon: const Icon(Icons.logout),
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final eventsAsync = ref.watch(fetchEventsProvider);

          if (eventsAsync.isLoading) {
            return const AppLoader();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fetchEventsProvider);
            },
            child: eventsAsync.when(
              loading: () => const AppLoader(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (events) => ListView.separated(
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(event: event);
                },
                separatorBuilder: (_, _) => const SizedBox(height: AppSizes.md),
                itemCount: events.length,
              ),
            ),
          );
        },
      ),
    );
  }
}
