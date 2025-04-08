import 'dart:convert';
import 'package:stormberry/stormberry.dart' as sb;

import 'package:tentura_root/domain/entity/date_range.dart';

class DateRangeConverter extends sb.TypeConverter<DateRange> {
  const DateRangeConverter() : super('tstzrange');

  @override
  dynamic encode(DateRange value) => sb.DateTimeRange(
    value.start,
    value.end,
    sb.Bounds(sb.Bound.inclusive, sb.Bound.inclusive),
  );

  @override
  DateRange decode(dynamic value) {
    switch (value) {
      case final String value:
        final json = jsonDecode(value) as List;
        return DateRange(
          start: DateTime.parse(json.first as String),
          end: DateTime.parse(json.last as String),
        );

      case final sb.DateTimeRange value:
        return DateRange(start: value.lower, end: value.upper);

      default:
        throw const FormatException('Wrong DateTimeRange value to decode!');
    }
  }
}
