import 'package:uni_life_rsvp_exam/features/events/data/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents();
  Future<Event> getEvent(String id);
  Future<void> toggleEventRsvp(String id, bool confirm);
}
