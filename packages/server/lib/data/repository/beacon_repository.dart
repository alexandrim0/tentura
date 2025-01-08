import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/beacon_model.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/exception.dart';

export 'package:tentura_server/domain/entity/beacon_entity.dart';

@Singleton(
  env: [
    Environment.dev,
    Environment.prod,
  ],
)
class BeaconRepository {
  BeaconRepository(this._database);

  final Database _database;

  Future<BeaconEntity> createBeacon(BeaconEntity beacon) async {
    await _database.beacons.insertOne(BeaconInsertRequest(
      id: beacon.id,
      userId: beacon.author.id,
      title: beacon.title,
      description: beacon.description,
      hasPicture: beacon.hasPicture,
      createdAt: beacon.createdAt,
      updatedAt: beacon.updatedAt,
      enabled: beacon.isEnabled,
      timerange: beacon.timerange,
      context: beacon.context,
      lat: beacon.coordinates?.latitude,
      long: beacon.coordinates?.longitude,
    ));
    return getBeaconById(beacon.id);
  }

  Future<BeaconEntity> getBeaconById(String id) async =>
      switch (await _database.beacons.queryBeacon(id)) {
        final BeaconModel m => m.asEntity,
        null => throw IdNotFoundException(id),
      };
}
