import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/data/repository/geo_repository.dart';

class ChooseLocationDialog extends StatefulWidget {
  static Future<Location?> show(
    BuildContext context, {
    Coordinates? center,
  }) =>
      showDialog<Location>(
        context: context,
        useSafeArea: false,
        useRootNavigator: false,
        builder: (_) => ChooseLocationDialog(
          center: center == null ? null : LatLng(center.lat, center.long),
        ),
      );

  final LatLng? center;

  const ChooseLocationDialog({
    this.center,
    super.key,
  });

  @override
  State<ChooseLocationDialog> createState() => _ChooseLocationDialogState();
}

class _ChooseLocationDialogState extends State<ChooseLocationDialog> {
  final _mapController = MapController();
  final _geoRepository = GetIt.I<GeoRepository>();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            forceMaterialTransparency: true,
            foregroundColor: Colors.black,
            title: const Text('Tap to choose location'),
          ),
          extendBodyBehindAppBar: true,
          body: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              maxZoom: 12,
              initialZoom: widget.center == null ? 4 : 10,
              initialCenter: widget.center ?? const LatLng(0, 0),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onTap: (tapPosition, point) async {
                final coords = (lat: point.latitude, long: point.longitude);
                final place = await _geoRepository.getPlaceNameByCoords(coords);
                if (context.mounted) {
                  await context.maybePop((coords: coords, place: place));
                }
              },
              onMapReady: () {
                if (widget.center == null ||
                    _geoRepository.myCoordinates == null) return;
                final center = widget.center ??
                    (_geoRepository.myCoordinates == null
                        ? null
                        : LatLng(
                            _geoRepository.myCoordinates!.lat,
                            _geoRepository.myCoordinates!.long,
                          ));
                if (center != null) {
                  _mapController.move(
                    center,
                    _mapController.camera.zoom,
                  );
                }
              },
            ),
            children: [
              TileLayer(
                userAgentPackageName: kAppLinkBase,
                urlTemplate: 'https://$kOsmLinkBase/{z}/{x}/{y}.png',
                tileProvider: CancellableNetworkTileProvider(
                  silenceExceptions: true,
                ),
              ),
              if (widget.center != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.center!,
                      child: const Icon(
                        Icons.place,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
}
