import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:built_value/serializer.dart';

class TstzrangeSerializer implements PrimitiveSerializer<DateTimeRange> {
  @override
  DateTimeRange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final json = jsonDecode(serialized as String) as List;
    return DateTimeRange(
      start: DateTime.parse(json.first as String),
      end: DateTime.parse(json.last as String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DateTimeRange tstzrange, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      jsonEncode([
        tstzrange.start.toIso8601String(),
        tstzrange.end.toIso8601String(),
      ]);

  @override
  Iterable<Type> get types => [DateTimeRange];

  @override
  String get wireName => 'DateTimeRange';
}
