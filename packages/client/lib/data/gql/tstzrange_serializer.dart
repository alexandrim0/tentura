import 'dart:convert';
import 'package:built_value/serializer.dart';

import 'package:tentura_root/domain/entity/date_range.dart';

class TstzrangeSerializer implements PrimitiveSerializer<DateRange> {
  @override
  DateRange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final json = jsonDecode(serialized as String) as List;
    return DateRange(
      start: DateTime.parse(json.first as String),
      end: DateTime.parse(json.last as String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DateRange tstzrange, {
    FullType specifiedType = FullType.unspecified,
  }) => jsonEncode([
    tstzrange.start?.toIso8601String(),
    tstzrange.end?.toIso8601String(),
  ]);

  @override
  Iterable<Type> get types => [DateRange];

  @override
  String get wireName => 'tstzrange';
}
