import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/service/image_service.dart';
import 'package:tentura_server/domain/exception.dart';

import 'beacon_repository.dart';

@Injectable(as: BeaconRepository, env: [Environment.test], order: 1)
class BeaconRepositoryMock implements BeaconRepository {
  static final storageById = <String, BeaconEntity>{};

  BeaconRepositoryMock(this._imageService);

  final ImageService _imageService;

  @override
  Future<BeaconEntity> createBeacon(BeaconEntity beacon) async =>
      storageById.containsKey(beacon.id)
          ? throw Exception('Key already exists [${beacon.id}]')
          : storageById[beacon.id] = beacon;

  @override
  Future<BeaconEntity> getBeaconById({
    required String beaconId,
    String? filterByUserId,
  }) async {
    final beacon =
        storageById[beaconId] ?? (throw IdNotFoundException(beaconId));
    if (filterByUserId != null && beacon.author.id != filterByUserId) {
      throw IdNotFoundException(beaconId);
    }
    return beacon;
  }

  @override
  Future<void> deleteBeaconById(String id) async =>
      storageById.removeWhere((key, value) => value.id == id);

  @override
  Future<void> updateBeaconBlurHash({
    required String beaconId,
    required Uint8List imageBytes,
  }) async => storageById.update(
    beaconId,
    (beacon) => beacon.copyWith(
      blurHash: _imageService.calculateBlurHash(
        _imageService.decodeImage(imageBytes),
      ),
    ),
  );
}
