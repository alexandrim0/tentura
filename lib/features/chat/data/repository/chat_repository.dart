import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/gql/_g/schema.schema.gql.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/repository_event.dart';

import '../../domain/exception.dart';
import '../../domain/entity/chat_message.dart';
import '../gql/_g/message_create.req.gql.dart';
import '../gql/_g/message_set_delivered.req.gql.dart';
import '../gql/_g/messages_stream.req.gql.dart';
import '../model/message_model.dart';

@lazySingleton
class ChatRepository {
  ChatRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  final _controller =
      StreamController<RepositoryEvent<ChatMessage>>.broadcast();

  Stream<RepositoryEvent<ChatMessage>> get changes => _controller.stream;

  @disposeMethod
  Future<void> dispose() => _controller.close();

  Stream<Iterable<ChatMessage>> watchUpdates({
    int batchSize = 10,
    DateTime? fromMoment,
  }) =>
      _remoteApiService
          .request(GMessageStreamReq(
            (b) => b.vars
              ..batch_size = batchSize
              ..updated_at = fromMoment,
          ))
          .map((e) => e.dataOrThrow(label: _label).message_stream)
          .map((e) => e.map((v) => (v as MessageModel).toEntity));

  Future<ChatMessage> sendMessage(ChatMessage message) => _remoteApiService
      .request(GMessageCreateReq(
        (b) => b.vars
          ..object = message.object
          ..message = message.content,
      ))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).insert_message_one)
      .then(
        (v) => v == null
            ? throw ChatMessageCreateException(message)
            : message.copyWith(
                createdAt: v.created_at,
                id: v.id.value,
              ),
      );

  Future<DateTime> setMessageSeen(String id) => _remoteApiService
      .request(
        GMessageSetDeliveredReq(
            (b) => b.vars.id = (GuuidBuilder()..value = id)),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).update_message_by_pk)
      .then(
        (v) => v == null ? throw ChatMessageUpdateException(id) : v.updated_at,
      );

  static const _label = 'Chat';
}
