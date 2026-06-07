import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uni_life_rsvp_exam/core/utils/datetime_converter.dart';
import 'package:uni_life_rsvp_exam/features/home/data/models/app_user.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    String? id,
    String? title,
    String? description,
    String? location,
    @DateTimeConverter() DateTime? startTime,
    int? capacity,
    int? rsvpCount,
    bool? isRsvped,
    List<AppUser>? attendees,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
