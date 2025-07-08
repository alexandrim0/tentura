import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/data/database/database.dart';
import 'package:tentura/data/gql/_g/schema.schema.gql.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/enum.dart';

import '../../domain/entity/chat_message_entity.dart';
import '../gql/_g/message_create.req.gql.dart';
import '../gql/_g/message_set_delivered.req.gql.dart';
import '../gql/_g/messages_fetch.req.gql.dart';
import '../gql/_g/messages_stream.req.gql.dart';
import '../model/chat_message_local_model.dart';
import '../model/chat_message_remote_model.dart';

@singleton
class ChatRepository {
  ChatRepository(
    this._database,
    this._remoteApiService,
  );

  final Database _database;

  final RemoteApiService _remoteApiService;

  //
  //
  Stream<Iterable<ChatMessageEntity>> watchUpdates({
    required DateTime fromMoment,
    int batchSize = 10,
  }) => _remoteApiService
      .request(
        GMessageStreamReq(
          (b) => b.vars
            ..updated_at = fromMoment
            ..batch_size = batchSize,
        ),
      )
      .map((r) => r.dataOrThrow(label: _label).message_stream)
      .map((v) => v.map((e) => (e as ChatMessageRemoteModel).toEntity()));

  //
  //
  Future<void> sendMessage({
    required String receiverId,
    required String content,
  }) => _remoteApiService
      .request(
        GMessageCreateReq(
          (b) => b.vars
            ..object = receiverId
            ..message = content,
        ),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label));

  //
  //
  Future<void> setMessageSeen({
    required String messageId,
  }) => _remoteApiService
      .request(
        GMessageSetDeliveredReq(
          (b) => b.vars.id = (GuuidBuilder()..value = messageId),
        ),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).update_message_by_pk);

  //
  //
  Future<void> saveMessages({
    required Iterable<ChatMessageEntity> messages,
  }) => _database.managers.messages.bulkCreate(
    (messageCompanion) => [
      for (final message in messages)
        messageCompanion(
          id: message.id,
          objectId: message.reciever,
          subjectId: message.sender,
          content: message.content,
          createdAt: message.createdAt,
          updatedAt: message.updatedAt,
          status: message.status,
        ),
    ],
    mode: InsertMode.replace,
  );

  ///
  /// Fetch all messages from last updated and saves into local DB
  ///
  Future<void> syncMessagesFor({
    required String userId,
  }) async {
    final cursor = await getLastUpdatedMessageTimestamp(userId: userId);
    final newMessages = await _remoteApiService
        .request(GMessagesFetchReq((b) => b.vars.from = cursor))
        .firstWhere((e) => e.dataSource == DataSource.Link)
        .then((r) => r.dataOrThrow(label: _label));

    await _database.managers.messages.bulkCreate(
      (messageCompanion) => [
        for (final message in newMessages.message)
          messageCompanion(
            id: message.id.value,
            objectId: message.object,
            subjectId: message.subject,
            content: message.message,
            createdAt: message.created_at,
            updatedAt: message.updated_at,
            status: message.delivered
                ? ChatMessageStatus.seen
                : ChatMessageStatus.sent,
          ),
      ],
      mode: InsertMode.replace,
    );
  }

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

  static const _label = 'Chat';
}
