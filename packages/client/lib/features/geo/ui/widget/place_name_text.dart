import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/coordinates.dart';

import '../../data/repository/geo_repository.dart';
import '../../domain/entity/place.dart';

class PlaceNameText extends StatelessWidget {
  const PlaceNameText({
    required this.coords,
    this.style,
    super.key,
  });

  final Coordinates coords;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final geoRepository = GetIt.I<GeoRepository>();
    final place = geoRepository.cache[coords];
    return place == null
        ? FutureBuilder(
            future: geoRepository.getLocationByCoords(coords),
            builder: (context, snapshot) => _buildText(snapshot.data?.place),
          )
        : _buildText(place);
  }

  Text _buildText(Place? place) => Text(
        place?.toString() ?? coords.toString(),
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
}
