import 'package:latlong2/latlong.dart';
import 'package:stormberry/stormberry.dart';

class LatLngConverter extends TypeConverter<LatLng> {
  const LatLngConverter() : super('point');

  @override
  dynamic encode(LatLng value) => Point(value.latitude, value.longitude);

  @override
  LatLng decode(dynamic value) {
    if (value is Point) {
      return LatLng(value.latitude, value.longitude);
    } else {
      final m = RegExp(r'\((.+),(.+)\)').firstMatch(value.toString());
      return LatLng(
        double.parse(m!.group(1)!.trim()),
        double.parse(m.group(2)!.trim()),
      );
    }
  }
}
