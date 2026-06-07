import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/domain/repository/event_repository.dart';
import 'package:uni_life_rsvp_exam/features/events/providers/events_provider.dart';

import 'events_provider_test.mocks.dart';

@GenerateMocks([EventRepository])
void main() {
  late MockEventRepository repository;

  setUp(() {
    repository = MockEventRepository();
  });

  /// Builds a [ProviderContainer] with the repository overridden by the mock,
  /// per https://riverpod.dev/docs/how_to/testing. The container is disposed
  /// automatically when the test finishes.
  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [eventRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('RsvpNotifier.toggleRsvp', () {
    test(
      'user cannot RSVP to the same event twice (toggling behavior)',
      () async {
        // An event the user has not yet RSVPed to.
        const event = Event(
          id: 'event-1',
          title: 'Orientation Week',
          rsvpCount: 3,
          isRsvped: false,
        );

        when(repository.toggleEventRsvp(any, any)).thenAnswer((_) async {});
        when(repository.getEvent('event-1')).thenAnswer((_) async => event);

        final container = createContainer();
        final notifier = container.read(rsvpProvider.notifier);

        // First tap: add the RSVP. Second tap on the now-RSVPed event: the UI
        // sends confirm:false, which removes it instead of adding a duplicate.
        await notifier.toggleRsvp(event, true);
        await notifier.toggleRsvp(event, false);

        // The repository is asked to add the RSVP, then remove it — never to add
        // a duplicate RSVP for the same event.
        verifyInOrder([
          repository.toggleEventRsvp('event-1', true),
          repository.toggleEventRsvp('event-1', false),
        ]);
        verifyNever(repository.toggleEventRsvp('event-1', true));

        // Final state is a clean success, not an error.
        expect(container.read(rsvpProvider), const AsyncData<Event?>(null));
      },
    );
  });

  group('RSVP count', () {
    test('count updates correctly when an RSVP is added then removed', () async {
      const baseEvent = Event(
        id: 'event-1',
        title: 'Orientation Week',
        rsvpCount: 3,
        isRsvped: false,
      );

      when(repository.toggleEventRsvp(any, any)).thenAnswer((_) async {});

      // The backend increments the count and flips isRsvped after an RSVP, and
      // decrements it after a cancel. fetchEvent re-reads this updated state.
      final responses = <Event>[
        baseEvent.copyWith(rsvpCount: 4, isRsvped: true), // after RSVP add
        baseEvent.copyWith(rsvpCount: 3, isRsvped: false), // after RSVP remove
      ];
      var call = 0;
      when(
        repository.getEvent('event-1'),
      ).thenAnswer((_) async => responses[call++]);

      final container = createContainer();
      final notifier = container.read(rsvpProvider.notifier);

      // Add the RSVP -> count goes 3 -> 4 and isRsvped becomes true.
      await notifier.toggleRsvp(baseEvent, true);
      final afterAdd = await container.read(
        fetchEventProvider('event-1').future,
      );
      expect(afterAdd.rsvpCount, 4);
      expect(afterAdd.isRsvped, true);

      // Cancel the RSVP -> count goes back 4 -> 3 and isRsvped becomes false.
      container.invalidate(fetchEventProvider('event-1'));
      await notifier.toggleRsvp(afterAdd, false);
      final afterRemove = await container.read(
        fetchEventProvider('event-1').future,
      );
      expect(afterRemove.rsvpCount, 3);
      expect(afterRemove.isRsvped, false);
    });
  });
}
