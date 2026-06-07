// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['id'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  location: json['location'] as String?,
  startTime: const DateTimeConverter().fromJson(json['startTime']),
  capacity: (json['capacity'] as num?)?.toInt(),
  rsvpCount: (json['rsvpCount'] as num?)?.toInt(),
  isRsvped: json['isRsvped'] as bool?,
  attendees: (json['attendees'] as List<dynamic>?)
      ?.map((e) => AppUser.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'startTime': _$JsonConverterToJson<Object?, DateTime>(
    instance.startTime,
    const DateTimeConverter().toJson,
  ),
  'capacity': instance.capacity,
  'rsvpCount': instance.rsvpCount,
  'isRsvped': instance.isRsvped,
  'attendees': instance.attendees,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
