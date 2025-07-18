import 'package:injectable/injectable.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'package:tentura_root/domain/enums.dart';

import 'package:tentura_server/domain/entity/user_presence_entity.dart';

import '../database/tentura_db.dart';
import '../mapper/user_presence_mapper.dart';

@Injectable(
  env: [
    Environment.dev,
    Environment.prod,
  ],
  order: 1,
)
class UserPresenceRepository {
  const UserPresenceRepository(this._database);

  final TenturaDb _database;

  //
  //
  Future<UserPresenceEntity> get(String userId) => _database
      .managers
      .userPresence
      .filter((t) => t.userId.id(userId))
      .getSingle()
      .then(userPresenceModelToEntity);

  //
  //
  Future<void> update(
    String userId, {
    UserPresenceStatus? status,
  }) async {
    await _database.managers.userPresence
        .filter((t) => t.userId.id(userId))
        .update(
          (o) => o(
            userId: Value(userId),
            status: Value.absentIfNull(status),
            lastSeenAt: Value(PgDateTime(DateTime.timestamp())),
          ),
        );
  }
}
