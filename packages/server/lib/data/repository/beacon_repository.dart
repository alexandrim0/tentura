import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/beacon_model.dart';
import 'package:tentura_server/data/service/image_service.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/exception.dart';

export 'package:tentura_server/domain/entity/beacon_entity.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class BeaconRepository {
  BeaconRepository(this._database, this._imageService);

  final Database _database;

  final ImageService _imageService;

  Future<BeaconEntity> createBeacon(BeaconEntity beacon) async {
    await _database.beacons.insertOne(
      BeaconInsertRequest(
        id: beacon.id,
        userId: beacon.author.id,
        title: beacon.title,
        description: beacon.description,
        hasPicture: beacon.hasPicture,
        picHeight: beacon.picHeight,
        picWidth: beacon.picWidth,
        blurHash: beacon.blurHash,
        createdAt: beacon.createdAt,
        updatedAt: beacon.updatedAt,
        enabled: beacon.isEnabled,
        timerange: beacon.timerange,
        context: beacon.context,
        lat: beacon.coordinates?.latitude,
        long: beacon.coordinates?.longitude,
      ),
    );
    return getBeaconById(beaconId: beacon.id);
  }

  ///
  /// Query Beacon by beaconId, filter by userId if set
  ///
  Future<BeaconEntity> getBeaconById({
    required String beaconId,
    String? filterByUserId,
  }) async {
    final beaconModel =
        await _database.beacons.queryBeacon(beaconId) ??
        (throw IdNotFoundException(id: beaconId));

    if (filterByUserId != null && beaconModel.user.id != filterByUserId) {
      throw IdNotFoundException(id: beaconId);
    }

    return (beaconModel as BeaconModel).asEntity;
  }

  Future<void> updateBeaconBlurHash({
    required String beaconId,
    required Uint8List imageBytes,
  }) => _database.beacons.updateOne(
    BeaconUpdateRequest(
      blurHash: _imageService.calculateBlurHash(
        _imageService.decodeImage(imageBytes),
      ),
      id: beaconId,
    ),
  );

  Future<void> deleteBeaconById(String id) => _database.beacons.deleteOne(id);
}
