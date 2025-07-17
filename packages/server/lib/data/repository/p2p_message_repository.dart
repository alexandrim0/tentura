import 'package:drift_postgres/drift_postgres.dart';
import 'package:injectable/injectable.dart';

import '../database/tentura_db.dart';

@Injectable(
  env: [
    Environment.dev,
    Environment.prod,
  ],
  order: 1,
)
class P2pMessageRepository {
  const P2pMessageRepository(this._database);

  final TenturaDb _database;

  //
  //
  Future<void> create({
    required String content,
    required String senderId,
    required String receiverId,
    required UuidValue clientId,
  }) async {
    await _database.managers.p2pMessages.create(
      (o) => o(
        clientId: clientId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
      ),
    );
  }

  ///
  /// Return number of affected rows
  ///
  Future<int> markAsDelivered({
    required String clientId,
    required String serverId,
    required String receiverId,
  }) => _database.managers.p2pMessages
      .filter(
        (e) =>
            e.clientId(UuidValue.fromString(clientId)) &
            e.serverId(UuidValue.fromString(serverId)) &
            e.receiverId.id(receiverId),
      )
      .update(
        (o) => o(
          deliveredAt: Value(PgDateTime(DateTime.timestamp())),
        ),
      );

  // Future<P2pMessageEntity?> fetchById(String id) => _database
  //     .managers
  //     .p2pMessages
  //     .filter((e) => e.id(UuidValue.fromString(id)))
  //     .getSingleOrNull()
  //     .then((e) => e == null ? null : p2pMessageModelToEntity(e));

  // Future<void> fetchBySubjectId({
  //   required String id,
  //   required DateTime from,
  //   int limit = 10,
  // }) async {
  //   await _database.managers.p2pMessages
  //       .filter(
  //         (e) =>
  //             e.subject.id(id) &
  //             e.createdAt.column.isBiggerThanValue(PgDateTime(from)),
  //       )
  //       .get(limit: limit);
  // }

  // Future<void> fetchByObjectId({
  //   required String id,
  //   required DateTime from,
  //   int limit = 10,
  // }) async {
  //   await _database.managers.p2pMessages
  //       .filter(
  //         (e) =>
  //             e.object.id(id) &
  //             e.createdAt.column.isBiggerThanValue(PgDateTime(from)),
  //       )
  //       .get(limit: limit);
  // }
}
