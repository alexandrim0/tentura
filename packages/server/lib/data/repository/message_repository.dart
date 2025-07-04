import 'package:drift_postgres/drift_postgres.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/chat_message_entity.dart';

import '../database/tentura_db.dart';
import '../mapper/chat_message_mapper.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class MessageRepository with ChatMessageMapper {
  const MessageRepository(this._database);

  final TenturaDb _database;

  Future<ChatMessageEntity> fetchById(String id) => _database.managers.messages
      .filter((e) => e.id(UuidValue.fromString(id)))
      .getSingle()
      .then(messageModelToEntity);

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
