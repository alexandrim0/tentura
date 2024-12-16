import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../domain/use_case/geo_case.dart';

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
    final geoCase = GetIt.I<GeoCase>();
    final place = geoCase.getCached(coords);
    return place == null
        ? FutureBuilder(
            future: geoCase.getLocationByCoords(coords),
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
