import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, Object?> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json == null) return DateTime.now();
    if (json is String) return DateTime.parse(json).toLocal();
    // if (json is Timestamp) return json.toDate().toLocal();
    throw ArgumentError(
      'Expected String or Timestamp, got ${json.runtimeType}',
    );
  }

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
