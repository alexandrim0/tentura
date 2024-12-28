import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

import 'package:tentura/consts.dart';

import '../../domain/use_case/geo_case.dart';

class ChooseLocationDialog extends StatefulWidget {
  static Future<Location?> show(
    BuildContext context, {
    Coordinates? center,
  }) =>
      showDialog<Location>(
        context: context,
        useSafeArea: false,
        builder: (_) => ChooseLocationDialog(
          center: center == null
              ? null
              : Coordinates(
                  lat: center.lat,
                  long: center.long,
                ),
        ),
      );

  final Coordinates? center;

  const ChooseLocationDialog({
    this.center,
    super.key,
  });

  @override
  State<ChooseLocationDialog> createState() => _ChooseLocationDialogState();
}

class _ChooseLocationDialogState extends State<ChooseLocationDialog> {
  final _mapController = MapController();
  final _geoCase = GetIt.I<GeoCase>();

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
              initialCenter: widget.center ?? Coordinates.zero,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onTap: (tapPosition, point) async {
                final location = await _geoCase.getLocationByCoords(Coordinates(
                  lat: point.latitude,
                  long: point.longitude,
                ));
                if (context.mounted) Navigator.of(context).pop(location);
              },
              onMapReady: () {
                if (widget.center != null) {
                  _mapController.move(
                    widget.center!,
                    _mapController.camera.zoom,
                  );
                } else {
                  final myCoordinates = _geoCase.myCoordinates;
                  if (myCoordinates != null) {
                    _mapController.move(
                      Coordinates(
                        lat: myCoordinates.lat,
                        long: myCoordinates.long,
                      ),
                      _mapController.camera.zoom,
                    );
                  }
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: kOsmUrlTemplate,
                userAgentPackageName: kAppTitle,
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
