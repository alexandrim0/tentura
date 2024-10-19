import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/features/chat/data/gql/_g/message_create.req.gql.dart';

import '../../domain/entity/chat_message.dart';
import '../../domain/exception.dart';

@lazySingleton
class ChatRepository {
  ChatRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  final _controller =
      StreamController<RepositoryEvent<ChatMessage>>.broadcast();

  Stream<RepositoryEvent<ChatMessage>> get changes => _controller.stream;

  @disposeMethod
  Future<void> dispose() => _controller.close();

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

  static const _label = 'Chat';
}
