import 'package:drift_postgres/drift_postgres.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/chat_message_entity.dart';

import '../database/tentura_db.dart';
import '../mapper/chat_message_mapper.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class MessageRepository with ChatMessageMapper {
  const MessageRepository(this._database);

  final TenturaDb _database;

  //
  //
  Future<ChatMessageEntity> create({
    required String content,
    required String subjectId,
    required String objectId,
  }) async {
    final message = await _database.managers.messages.createReturning(
      (o) => o(
        object: objectId,
        subject: subjectId,
        message: content,
      ),
    );
    return messageModelToEntity(message);
  }

  ///
  /// Return number of affected rows
  ///
  Future<int> markAsDelivered({
    required String id,
    required String objectId,
  }) => _database.managers.messages
      .filter((e) => e.id(UuidValue.fromString(id)) & e.object.id(objectId))
      .update(
        (o) => o(
          delivered: const Value(true),
          updatedAt: Value(
            PgDateTime(DateTime.timestamp()),
          ),
        ),
      );

  Future<ChatMessageEntity?> fetchById(String id) => _database.managers.messages
      .filter((e) => e.id(UuidValue.fromString(id)))
      .getSingleOrNull()
      .then((e) => e == null ? null : messageModelToEntity(e));

  Future<void> fetchBySubjectId({
    required String id,
    required DateTime from,
    int limit = 10,
  }) async {
    await _database.managers.messages
        .filter(
          (e) =>
              e.subject.id(id) &
              e.createdAt.column.isBiggerThanValue(PgDateTime(from)),
        )
        .get(limit: limit);
  }

  Future<void> fetchByObjectId({
    required String id,
    required DateTime from,
    int limit = 10,
  }) async {
    await _database.managers.messages
        .filter(
          (e) =>
              e.object.id(id) &
              e.createdAt.column.isBiggerThanValue(PgDateTime(from)),
        )
        .get(limit: limit);
  }
}
