import 'package:drift_postgres/drift_postgres.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/p2p_message_entity.dart';

import '../database/tentura_db.dart';
import '../mapper/p2p_message_mapper.dart';

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

  //
  //
  Future<Iterable<P2pMessageEntity>> fetchByUserId({
    required DateTime from,
    required String id,
    required int limit,
  }) => _database.managers.p2pMessages
      .filter(
        (e) =>
            (e.receiverId.id(id) &
                e.createdAt.column.isBiggerThanValue(PgDateTime(from))) |
            (e.senderId.id(id) &
                e.createdAt.column.isBiggerThanValue(PgDateTime(from))) |
            (e.senderId.id(id) &
                e.deliveredAt.column.isBiggerThanValue(PgDateTime(from))),
      )
      .orderBy((o) => o.createdAt.asc())
      .get(limit: limit)
      .then((e) => e.map(p2pMessageModelToEntity));
}
