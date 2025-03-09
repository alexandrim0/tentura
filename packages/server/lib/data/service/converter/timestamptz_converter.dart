import 'package:stormberry/stormberry.dart' as sb;

class TimestamptzConverter extends sb.TypeConverter<DateTime> {
  const TimestamptzConverter() : super('timestamptz');

  @override
  dynamic encode(DateTime value) => value.toIso8601String();

  @override
  DateTime decode(dynamic value) => switch (value) {
    final String v => DateTime.parse(v),
    final DateTime v => v,
    _ => throw const FormatException('Wrong timestamptz value to decode!'),
  };
}
