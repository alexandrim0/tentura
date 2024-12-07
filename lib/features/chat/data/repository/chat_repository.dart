import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/database/database.dart';
import 'package:tentura/data/gql/_g/schema.schema.gql.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/enum.dart';

import '../../domain/entity/chat_message.dart';
import '../gql/_g/message_create.req.gql.dart';
import '../gql/_g/message_set_delivered.req.gql.dart';
import '../gql/_g/messages_fetch.req.gql.dart';
import '../gql/_g/messages_stream.req.gql.dart';
import '../service/chat_mappers.dart';

@singleton
class ChatRepository {
  ChatRepository(
    this._database,
    this._remoteApiService,
  );

  final Database _database;

  final RemoteApiService _remoteApiService;

  Stream<Iterable<ChatMessage>> watchUpdates(DateTime fromMoment) =>
      _remoteApiService
          .request(GMessageStreamReq((b) => b.vars.updated_at = fromMoment))
          .map((r) => r.dataOrThrow(label: _label).message_stream)
          .map((v) => v.map(toEntityFrom));
  // .map((v) => v.map((e) => toEntityFrom(e as GMessageModel)));

  Future<void> sendMessage(ChatMessage message) => _remoteApiService
      .request(
        GMessageCreateReq((b) => b.vars
          ..object = message.reciever
          ..message = message.content),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label));

  Future<void> setMessageSeen(String id) => _remoteApiService
      .request(GMessageSetDeliveredReq(
        (b) => b.vars.id = (GuuidBuilder()..value = id),
      ))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).update_message_by_pk);

  /// Fetch all messages from last updated and saves into local DB
  Future<void> syncMessagesFor(String id) async {
    final table = _database.messages;
    final expr = table.updatedAt.max();
    final last = await (_database.selectOnly(table)
          ..addColumns([expr])
          ..where(table.objectId.equals(id) | table.subjectId.equals(id)))
        .map((r) => r.read(expr))
        .getSingleOrNull();

    final newMessages = await _remoteApiService
        .request(
          GMessagesFetchReq((b) => b.vars.from = last?.toUtc() ?? _zeroAge),
        )
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

  /// Get all messages for pair from local DB
  Future<Iterable<ChatMessage>> getChatMessagesFor({
    required String objectId,
    required String subjectId,
  }) =>
      _database.managers.messages
          .filter((f) =>
              f.objectId.equals(objectId) & f.subjectId.equals(subjectId) |
              f.objectId.equals(subjectId) & f.subjectId.equals(objectId))
          .orderBy((o) => o.createdAt.asc())
          .get()
          .then((v) => v.map(toEntityFrom));

  /// Get all unseen messages for user from local DB
  Future<Iterable<ChatMessage>> getAllNewMessagesFor(String id) =>
      _database.managers.messages
          .filter((f) =>
              f.objectId.equals(id) & f.status.equals(ChatMessageStatus.sent))
          .get()
          .then((v) => v.map(toEntityFrom));

  static const _label = 'Chat';

  static final _zeroAge = DateTime.fromMillisecondsSinceEpoch(0);
}
