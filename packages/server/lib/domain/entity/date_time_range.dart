import 'package:meta/meta.dart';

@immutable
class DateTimeRange {
  const DateTimeRange({
    this.start,
    this.end,
  }) : assert(
          start != null || end != null,
          'At least one parameter should be not null',
        );

  final DateTime? start;

  final DateTime? end;

  @override
  bool operator ==(Object other) {
    if (other is DateTimeRange) {
      return other.start == start && other.end == end;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';
}
