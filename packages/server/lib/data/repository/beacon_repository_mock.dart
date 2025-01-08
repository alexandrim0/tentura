import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/exception.dart';

import 'beacon_repository.dart';

export 'package:tentura_server/domain/entity/beacon_entity.dart';

@Singleton(
  as: BeaconRepository,
  env: [
    Environment.test,
  ],
)
class BeaconRepositoryMock implements BeaconRepository {
  @override
  Future<BeaconEntity> createBeacon(BeaconEntity beacon) async =>
      _storageById[beacon.id] = beacon;

  @override
  Future<BeaconEntity> getBeaconById(String id) async =>
      _storageById[id] ?? (throw IdNotFoundException(id));

  static final _storageById = <String, BeaconEntity>{};
}
