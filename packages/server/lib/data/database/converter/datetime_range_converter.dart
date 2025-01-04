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
    if (value is DateTimeRange) {
      return DateTimeRange(
        value.start,
        value.end,
      );
    } else {
      final m = RegExp(r'\["(.+)","(.+)"\]').firstMatch(value.toString());
      return DateTimeRange(
        DateTime.parse(m!.group(1)!),
        DateTime.parse(m.group(2)!),
      );
    }
  }
}
