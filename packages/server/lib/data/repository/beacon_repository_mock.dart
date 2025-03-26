import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/exception.dart';

import 'beacon_repository.dart';

@Injectable(as: BeaconRepository, env: [Environment.test], order: 1)
class BeaconRepositoryMock implements BeaconRepository {
  static final storageById = <String, BeaconEntity>{};

  const BeaconRepositoryMock();

  @override
  Future<BeaconEntity> createBeacon(
    BeaconEntity beacon, {
    int ticker = 0,
  }) async =>
      storageById.containsKey(beacon.id)
          ? throw Exception('Key already exists [${beacon.id}]')
          : storageById[beacon.id] = beacon;

  @override
  Future<BeaconEntity> getBeaconById({
    required String beaconId,
    String? filterByUserId,
  }) async {
    final beacon =
        storageById[beaconId] ?? (throw IdNotFoundException(id: beaconId));
    if (filterByUserId != null && beacon.author.id != filterByUserId) {
      throw IdNotFoundException(id: beaconId);
    }
    return beacon;
  }

  @override
  Future<void> deleteBeaconById(String id) async =>
      storageById.removeWhere((key, value) => value.id == id);

  @override
  Future<void> updateBeaconImageDetails({
    required String beaconId,
    required String blurHash,
    required int imageHeight,
    required int imageWidth,
  }) async => storageById.update(
    beaconId,
    (beacon) => beacon.copyWith(
      blurHash: blurHash,
      picHeight: imageHeight,
      picWidth: imageWidth,
    ),
  );
}
