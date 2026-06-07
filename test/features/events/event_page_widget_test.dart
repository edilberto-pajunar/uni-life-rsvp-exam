import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/domain/repository/event_repository.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/pages/event_page.dart';
import 'package:uni_life_rsvp_exam/features/events/providers/events_provider.dart';

import 'event_page_widget_test.mocks.dart';

/// Widget tests for the Event Detail screen ([EventPage]).
///
/// Covers the loading and error states plus the headline case for the PRD: the
/// RSVP toggle is reflected in the UI. State is driven entirely through the
/// mocked [EventRepository], mirroring the unit-test override pattern.
@GenerateMocks([EventRepository])
void main() {
  late MockEventRepository repository;

  setUp(() {
    repository = MockEventRepository();
  });

  /// Pumps [EventPage] for [eventId] with the repository mock installed. A
  /// [MaterialApp] supplies the [Scaffold]/[ScaffoldMessenger] the page needs.
  Future<void> pumpEvent(WidgetTester tester, String eventId) {
    // A tall surface so the whole detail ListView (including the RSVP button at
    // the bottom) is laid out and findable without scrolling.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    return tester.pumpWidget(
      ProviderScope(
        overrides: [eventRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(home: EventPage(eventId: eventId)),
      ),
    );
  }

  const baseEvent = Event(
    id: 'event-1',
    title: 'Orientation Week',
    description: 'Kick off the semester.',
    location: 'Main Hall',
    capacity: 50,
    rsvpCount: 3,
    isRsvped: false,
    attendees: [],
  );

  testWidgets('shows a loader while the event is being fetched', (
    tester,
  ) async {
    final completer = Completer<Event>();
    when(repository.getEvent('event-1')).thenAnswer((_) => completer.future);

    await pumpEvent(tester, 'event-1');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(baseEvent); // settle to avoid a pending timer
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error message when the event fails to load', (
    tester,
  ) async {
    when(repository.getEvent('event-1')).thenThrow(Exception('not found'));

    await pumpEvent(tester, 'event-1');
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load event'), findsOneWidget);
  });

  testWidgets('shows the empty attendees state when nobody has RSVPed', (
    tester,
  ) async {
    when(repository.getEvent('event-1')).thenAnswer((_) async => baseEvent);

    await pumpEvent(tester, 'event-1');
    await tester.pumpAndSettle();

    expect(find.text('No RSVPs yet'), findsOneWidget);
  });

  testWidgets('RSVP toggle is reflected in the UI', (tester) async {
    // The backend flips isRsvped and bumps the count after an RSVP; the page
    // re-reads this via the invalidated fetchEventProvider. The first getEvent
    // returns the not-going event, the second the going one.
    final responses = <Event>[
      baseEvent,
      baseEvent.copyWith(rsvpCount: 4, isRsvped: true),
    ];
    var call = 0;
    when(
      repository.getEvent('event-1'),
    ).thenAnswer((_) async => responses[call++]);
    when(repository.toggleEventRsvp(any, any)).thenAnswer((_) async {});

    await pumpEvent(tester, 'event-1');
    await tester.pumpAndSettle();

    // Not going yet: primary "RSVP" button, "Open" status pill, 3/50 going.
    expect(find.text('RSVP'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('3 / 50 going'), findsOneWidget);
    expect(find.text('Confirmed'), findsNothing);

    await tester.tap(find.text('RSVP'));
    await tester.pumpAndSettle();

    // Going now: disabled "Confirmed" button, "Going" pill, count bumped to 4.
    verify(repository.toggleEventRsvp('event-1', true)).called(1);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('Going'), findsOneWidget);
    expect(find.text('4 / 50 going'), findsOneWidget);
    expect(find.text('RSVP'), findsNothing);
  });
}
