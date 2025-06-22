import 'package:injectable/injectable.dart';

import 'package:tentura_root/domain/entity/coordinates.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/domain/exception.dart';

import '../mapper/beacon_mapper.dart';
import '../mapper/polling_mapper.dart';
import '../mapper/user_mapper.dart';
import 'beacon_repository.dart';

@Injectable(as: BeaconRepository, env: [Environment.test], order: 1)
class BeaconRepositoryMock
    with UserMapper, PollingMapper, BeaconMapper
    implements BeaconRepository {
  static final storageById = <String, BeaconEntity>{};

  const BeaconRepositoryMock();

  @override
  Future<BeaconEntity> createBeacon({
    required String authorId,
    required String title,
    required bool hasPicture,
    String? description,
    String? context,
    double? latitude,
    double? longitude,
    DateTime? startAt,
    DateTime? endAt,
    ({String question, List<String> variants})? polling,
    int ticker = 0,
  }) async {
    final now = DateTime.timestamp();
    final beacon = BeaconEntity(
      id: BeaconEntity.newId,
      title: title,
      context: context,
      description: description ?? '',
      author: UserEntity(id: authorId),
      coordinates: latitude != null && longitude != null
          ? Coordinates(lat: latitude, long: longitude)
          : null,
      hasPicture: hasPicture,
      startAt: startAt,
      endAt: endAt,
      createdAt: now,
      updatedAt: now,
    );
    return storageById[beacon.id] = beacon;
  }

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
