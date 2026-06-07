import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/domain/repository/event_repository.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/event_card.dart';
import 'package:uni_life_rsvp_exam/features/events/providers/events_provider.dart';
import 'package:uni_life_rsvp_exam/features/home/presentation/pages/home_page.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_loader.dart';

import '../../helpers/firebase_mock.dart';
import 'home_page_widget_test.mocks.dart';

/// Widget tests for the Event List screen ([HomePage]).
///
/// Each meaningful UI state (loading / error / empty / data) is driven by
/// controlling the mocked [EventRepository], following the same override
/// pattern as the unit tests in
/// `test/features/events/events_provider_test.dart`.
@GenerateMocks([EventRepository])
void main() {
  late MockEventRepository repository;

  // The HomePage AppBar reads `authProvider`, which builds an
  // `AuthRepositoryImpl` -> `FirebaseAuth.instance` during build. Mock the
  // Firebase platform so that read doesn't throw `[core/no-app]`.
  setUpAll(() async {
    setupFirebaseMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    repository = MockEventRepository();
  });

  /// Pumps [HomePage] with the repository overridden by the mock. A
  /// [MaterialApp] is required because the page renders a [Scaffold]/[AppBar]
  /// through `AppScaffold`.
  Future<void> pumpHome(WidgetTester tester) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [eventRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: HomePage()),
      ),
    );
  }

  const events = <Event>[
    Event(id: 'event-1', title: 'Orientation Week', capacity: 50, rsvpCount: 3),
    Event(id: 'event-2', title: 'Hackathon Night', capacity: 30, rsvpCount: 10),
  ];

  testWidgets('shows a loader while events are being fetched', (tester) async {
    // A future that never completes keeps the provider in its loading state.
    final completer = Completer<List<Event>>();
    when(repository.getEvents()).thenAnswer((_) => completer.future);

    await pumpHome(tester);
    await tester.pump(); // build with the pending future

    expect(find.byType(AppLoader), findsOneWidget);

    completer.complete(
      const [],
    ); // let the future settle to avoid pending timers
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error message when fetching fails', (tester) async {
    when(repository.getEvents()).thenThrow(Exception('network down'));

    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(find.textContaining('Error:'), findsOneWidget);
    expect(find.byType(EventCard), findsNothing);
  });

  testWidgets('shows no event cards when the list is empty', (tester) async {
    when(repository.getEvents()).thenAnswer((_) async => const <Event>[]);

    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(find.byType(EventCard), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('renders an EventCard for each event', (tester) async {
    when(repository.getEvents()).thenAnswer((_) async => events);

    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(find.byType(EventCard), findsNWidgets(2));
    expect(find.text('Orientation Week'), findsOneWidget);
    expect(find.text('Hackathon Night'), findsOneWidget);
  });
}
