import 'package:injectable/injectable.dart';

import '../../data/repository/geo_repository.dart';
import '../entity/coordinates.dart';
import '../entity/location.dart';
import '../entity/place.dart';

export '../../domain/entity/coordinates.dart';
export '../../domain/entity/location.dart';
export '../../domain/entity/place.dart';

@lazySingleton
class GeoCase {
  const GeoCase(this._geoRepository);

  final GeoRepository _geoRepository;

  Coordinates? get myCoordinates => _geoRepository.myCoordinates;

  Place? getCached(Coordinates coords) => _geoRepository.cache[coords];

  Future<Location> getLocationByCoords(Coordinates coords) async => Location(
        coords: coords,
        place: await _geoRepository.getPlaceNameByCoords(coords),
      );
}
