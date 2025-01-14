import 'dart:convert';
import 'package:stormberry/stormberry.dart' as sb;

import 'package:tentura_server/domain/entity/date_time_range.dart';

class DateTimeRangeConverter extends sb.TypeConverter<DateTimeRange> {
  const DateTimeRangeConverter() : super('tstzrange');

  @override
  dynamic encode(DateTimeRange value) => sb.DateTimeRange(
        value.start,
        value.end,
        sb.Bounds(
          sb.Bound.inclusive,
          sb.Bound.inclusive,
        ),
      );

  @override
  DateTimeRange decode(dynamic value) {
    switch (value) {
      case final String value:
        final json = jsonDecode(value) as List;
        return DateTimeRange(
          start: DateTime.parse(json.first as String),
          end: DateTime.parse(json.last as String),
        );

      case final sb.DateTimeRange value:
        return DateTimeRange(
          start: value.lower,
          end: value.upper,
        );

      default:
        throw const FormatException(
          'Wrong DateTimeRange value to decode!',
        );
    }
  }
}
