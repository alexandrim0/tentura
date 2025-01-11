import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:stormberry/stormberry.dart';

class LatLngConverter extends TypeConverter<LatLng> {
  const LatLngConverter() : super('point');

  @override
  dynamic encode(LatLng value) => Point(
        value.latitude,
        value.longitude,
      );

  @override
  LatLng decode(dynamic value) {
    switch (value) {
      case final String value:
        final json = jsonDecode(value) as List;
        return LatLng(
          double.parse(json.first as String),
          double.parse(json.last as String),
        );

      case final Point value:
        return LatLng(
          value.latitude,
          value.longitude,
        );

      default:
        throw const FormatException(
          'Wrong Point value to decode!',
        );
    }
  }
}
