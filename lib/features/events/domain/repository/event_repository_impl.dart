import 'package:dio/dio.dart';
import 'package:uni_life_rsvp_exam/core/api/api_client.dart';
import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/events/domain/repository/event_repository.dart';

class EventRepositoryImpl extends ApiClient implements EventRepository {
  EventRepositoryImpl() : super(dio: Dio());

  @override
  Future<List<Event>> getEvents() async {
    final response = await get('/events');
    return (response.data as List).map((e) => Event.fromJson(e)).toList();
  }

  @override
  Future<Event> getEvent(String id) async {
    final response = await get('/events/$id');
    return Event.fromJson(response.data);
  }

  @override
  Future<void> toggleEventRsvp(String id, bool confirm) async {
    await post('/events/$id/rsvp', data: {'rsvp': confirm});
  }
}
