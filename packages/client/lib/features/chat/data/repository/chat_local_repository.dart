import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/enum.dart';
import 'package:tentura/data/database/database.dart';

import '../../domain/entity/chat_message_entity.dart';
import '../model/chat_message_local_model.dart';

@singleton
class ChatLocalRepository {
  ChatLocalRepository(this._database);

  final Database _database;

  //
  //
  Future<void> saveMessages({
    required Iterable<ChatMessageEntity> messages,
  }) => _database.managers.messages.bulkCreate(
    (messageCompanion) => [
      for (final message in messages)
        messageCompanion(
          id: message.id,
          objectId: message.receiverId,
          subjectId: message.senderId,
          content: message.content,
          createdAt: message.createdAt,
          updatedAt: message.deliveredAt ?? message.createdAt,
          status: message.status,
        ),
    ],
    mode: InsertMode.replace,
  );

  ///
  /// Get all messages for pair from local DB
  ///
  Future<Iterable<ChatMessageEntity>> getChatMessagesFor({
    required String objectId,
    required String subjectId,
  }) => _database.managers.messages
      .filter(
        (f) =>
            (f.objectId(objectId) & f.subjectId(subjectId)) |
            (f.objectId(subjectId) & f.subjectId(objectId)),
      )
      .orderBy((o) => o.createdAt.asc())
      .get()
      .then((v) => v.map((e) => (e as ChatMessageLocalModel).toEntity()));

  ///
  /// Get all unseen messages for user from local DB
  ///
  Future<Iterable<ChatMessageEntity>> getAllNewMessagesFor({
    required String userId,
  }) => _database.managers.messages
      .filter((f) => f.objectId(userId) & f.status(ChatMessageStatus.sent))
      .get()
      .then((v) => v.map((e) => (e as ChatMessageLocalModel).toEntity()));

  ///
  /// Get last updated message timestamp
  ///
  Future<DateTime> getLastUpdatedMessageTimestamp({
    required String userId,
  }) => _database.managers.messages
      .filter((f) => f.objectId(userId) | f.subjectId(userId))
      .orderBy((o) => o.updatedAt.desc())
      .limit(1)
      .getSingleOrNull()
      .then((e) => e?.updatedAt.toUtc() ?? zeroAge);
}
