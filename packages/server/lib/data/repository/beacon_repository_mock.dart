import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/utils/id.dart';

@Singleton(
  as: BeaconRepository,
  env: [
    Environment.test,
  ],
)
class BeaconRepositoryMock implements BeaconRepository {
  @override
  Future<BeaconEntity> createBeacon({
    required String userId,
    String? beaconId,
  }) async {
    beaconId ??= generateId(prefix: 'B');
    final now = DateTime.timestamp();
    return _storageById[beaconId] = BeaconEntity(
      id: beaconId,
      createdAt: now,
      updatedAt: now,
      author: UserEntity(
        id: userId,
      ),
    );
  }

  @override
  Future<BeaconEntity> getBeaconById(String beaconId) async =>
      _storageById[beaconId] ?? (throw const BeaconNotFoundException());

  static final _storageById = <String, BeaconEntity>{};
}
