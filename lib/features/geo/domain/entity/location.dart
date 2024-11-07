import 'coordinates.dart';
import 'place.dart';

class Location {
  const Location({
    this.coords = Coordinates.zero,
    this.place,
  });

  final Coordinates coords;

  final Place? place;

  bool get isEmpty => coords == Coordinates.zero && (place?.isEmpty ?? true);

  bool get isNotEmpty => !isEmpty;
}
