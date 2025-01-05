import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/beacon_model.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/utils/id.dart';

@Singleton(
  env: [
    Environment.dev,
    Environment.prod,
  ],
)
class BeaconRepository {
  BeaconRepository(this._database);

  final Database _database;

  Future<BeaconEntity> createBeacon({
    required String userId,
    String? beaconId,
  }) async {
    beaconId ??= generateId(prefix: 'B');
    final now = DateTime.timestamp();
    await _database.beacons.insertOne(BeaconInsertRequest(
      id: beaconId,
      userId: userId,
      title: '',
      description: '',
      hasPicture: false,
      createdAt: now,
      updatedAt: now,
      enabled: true,
    ));
    return getBeaconById(beaconId);
  }

  Future<BeaconEntity> getBeaconById(String beaconId) async =>
      switch (await _database.beacons.queryBeacon(beaconId)) {
        final BeaconModel m => m.asEntity,
        null => throw const BeaconNotFoundException(),
      };

  // Future<BeaconEntity> getBeaconById(String beaconId) async {
  //   final beacon = await _database.beacons.queryBeacon(beaconId);
  //   if (beacon == null) {
  //     throw const BeaconNotFoundException();
  //   }
  //   return (beacon as BeaconModel).asEntity;
  // }
}

class BeaconNotFoundException implements Exception {
  const BeaconNotFoundException([this.message]);

  final String? message;

  @override
  String toString() => 'BeaconNotFoundException: [$message]';
}
