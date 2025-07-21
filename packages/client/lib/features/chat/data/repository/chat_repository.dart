import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/enum.dart';
import 'package:tentura/data/database/database.dart';
import 'package:tentura/data/service/remote_api_service.dart';

import '../../domain/entity/chat_message_entity.dart';
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
  }) {
    _remoteApiService.webSocketSend(
      // TBD: move to Model
      jsonEncode({
        'type': 'subscription',
        'path': 'p2p_chat',
        'payload': {
          'intent': 'watch_updates',
          'params': {
            'batch_size': batchSize,
            'from_timestamp': fromMoment.toIso8601String(),
          },
        },
      }),
    );
    return _remoteApiService.webSocketMessages
        .where(
          (e) =>
              e['type'] == 'subscription' &&
              e['path'] == 'p2p_chat' &&
              e['payload'] is Map<String, dynamic> &&
              // ignore: avoid_dynamic_calls // temporary
              e['payload']['intent'] == 'watch_updates' &&
              // ignore: avoid_dynamic_calls // temporary
              e['payload']['messages'] is List<dynamic>,
        )
        // ignore: avoid_dynamic_calls // temporary
        .map((e) => e['payload']['messages'] as List<dynamic>)
        .map(
          (e) => e.map(
            (m) => ChatMessageRemoteModel.fromJson(
              m as Map<String, dynamic>,
            ).asEntity,
          ),
        );
  }

  //
  //
  Future<void> sendMessage({
    required String receiverId,
    required String clientId,
    required String content,
  }) async => _remoteApiService.webSocketSend(
    // TBD: move to Model
    jsonEncode({
      'type': 'message',
      'path': 'p2p_chat',
      'payload': {
        'intent': 'send_message',
        'message': {
          'receiver_id': receiverId,
          'client_id': clientId,
          'content': content,
        },
      },
    }),
  );

  //
  //
  Future<void> setMessageSeen({
    required String messageId,
  }) async => _remoteApiService.webSocketSend(
    // TBD: move to Model
    jsonEncode({
      'type': 'message',
      'path': 'p2p_chat',
      'payload': {
        'intent': 'mark_as_delivered',
        'message': {
          'message_id': messageId,
        },
      },
    }),
  );

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

  // static const _label = 'Chat';
}
