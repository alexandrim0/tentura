import 'package:stormberry/stormberry.dart' as sb;

class TimestamptzConverter extends sb.TypeConverter<DateTime> {
  const TimestamptzConverter() : super('timestamptz');

  @override
  dynamic encode(DateTime value) => value;

  @override
  DateTime decode(dynamic value) => switch (value) {
    final DateTime v => v,
    final String v => DateTime.parse(v),
    _ => throw const FormatException('Wrong timestamptz value to decode!'),
  };
}
