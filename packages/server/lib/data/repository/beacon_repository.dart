import 'package:injectable/injectable.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';

import '../database/tentura_db.dart';
import '../mapper/beacon_mapper.dart';
import '../mapper/user_mapper.dart';

export 'package:tentura_server/domain/entity/beacon_entity.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class BeaconRepository with UserMapper, BeaconMapper {
  const BeaconRepository(this._database);

  final TenturaDb _database;

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
    int ticker = 0,
  }) async {
    final beacon = await _database.managers.beacons.createReturning(
      (o) => o(
        userId: authorId,
        title: title,
        context: Value(context),
        description: Value(description ?? ''),
        hasPicture: Value(hasPicture),
        ticker: Value(ticker),
        lat: Value(latitude),
        long: Value(longitude),
        startAt: Value(startAt == null ? null : PgDateTime(startAt)),
        endAt: Value(endAt == null ? null : PgDateTime(endAt)),
      ),
    );
    final author =
        await _database.managers.users
            .filter((e) => e.id.equals(authorId))
            .getSingle();
    return beaconModelToEntity(beacon, author: author);
  }

  ///
  /// Query Beacon by beaconId, filter by userId if set
  ///
  Future<BeaconEntity> getBeaconById({
    required String beaconId,
    String? filterByUserId,
  }) async {
    final (beacon, author) =
        await _database.managers.beacons
            .filter(
              filterByUserId == null
                  ? (e) => e.id.equals(beaconId)
                  : (e) =>
                      e.id.equals(beaconId) &
                      e.userId.id.equals(filterByUserId),
            )
            .withReferences((p) => p(userId: true))
            .getSingle();

    return beaconModelToEntity(beacon, author: await author.userId.getSingle());
  }

  Future<void> updateBeaconImageDetails({
    required String beaconId,
    required String blurHash,
    required int imageHeight,
    required int imageWidth,
  }) async {
    final beacon =
        await _database.managers.beacons
            .filter((e) => e.id.equals(beaconId))
            .getSingle();
    await _database.managers.beacons.replace(
      beacon.copyWith(
        picHeight: imageHeight,
        picWidth: imageWidth,
        blurHash: blurHash,
      ),
    );
  }

  Future<void> deleteBeaconById(String id) =>
      _database.managers.beacons.filter((e) => e.id.equals(id)).delete();
}
