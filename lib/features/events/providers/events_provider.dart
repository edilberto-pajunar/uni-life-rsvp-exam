import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/domain/repository/event_repository.dart';
import 'package:uni_life_rsvp_exam/features/events/domain/repository/event_repository_impl.dart';

part 'events_provider.g.dart';

/// Exposes the event repository through Riverpod so it can be overridden with a
/// mock in tests. Defaults to the real [EventRepositoryImpl] in production.
@riverpod
EventRepository eventRepository(Ref ref) => EventRepositoryImpl();

@riverpod
class EventsNotifier extends _$EventsNotifier {
  // initial value
  @override
  Set<Event> build() {
    return {};
  }

  // methods to update state
}

@riverpod
class RsvpNotifier extends _$RsvpNotifier {
  @override
  AsyncValue<Event?> build() => const AsyncData(null);

  Future<void> toggleRsvp(Event event, bool confirm) async {
    if (state.isLoading) return;

    final eventId = event.id;
    if (eventId == null) {
      state = AsyncError(ArgumentError('Event id is null'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final result = await AsyncValue.guard(
      () => ref.read(eventRepositoryProvider).toggleEventRsvp(eventId, confirm),
    );

    if (result case AsyncError(:final error, :final stackTrace)) {
      state = AsyncError(error, stackTrace);
      return;
    }

    state = const AsyncData(null);
    ref.invalidate(fetchEventProvider(eventId));
  }
}

@riverpod
Future<List<Event>> fetchEvents(Ref ref) async {
  return ref.read(eventRepositoryProvider).getEvents();
}

@riverpod
Future<Event> fetchEvent(Ref ref, String id) async {
  return ref.read(eventRepositoryProvider).getEvent(id);
}
