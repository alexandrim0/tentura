import 'package:latlong2/latlong.dart';

class Coordinates extends LatLng {
  static const zero = Coordinates(lat: 0, long: 0);

  const Coordinates({required double lat, required double long})
    : super(lat, long);

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      Coordinates(lat: json['lat']! as double, long: json['long']! as double);

  double get lat => latitude;

  double get long => longitude;

  bool get isEmpty => latitude == 0 && longitude == 0;

  bool get isNotEmpty => latitude != 0 && longitude != 0;

  @override
  String toString() => '($latitude, $longitude)';

  @override
  Map<String, Object> toJson() => {'lat': latitude, 'long': longitude};
}
