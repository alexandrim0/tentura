import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/model/user_model.dart';
import 'package:tentura/data/gql/_g/schema.schema.gql.dart';
import 'package:tentura/data/service/remote_api_service.dart';

import '../../domain/typedef.dart';
import '../../domain/entity/chat_message.dart';
import '../gql/_g/message_create.req.gql.dart';
import '../gql/_g/message_set_delivered.req.gql.dart';
import '../gql/_g/messages_fetch.req.gql.dart';
import '../gql/_g/messages_stream.req.gql.dart';
import '../model/message_model.dart';

@singleton
class ChatRepository {
  ChatRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Stream<ChatMessage> watchUpdates(DateTime? fromMoment) => _remoteApiService
      .request(GMessageStreamReq((b) => b.vars.updated_at = fromMoment))
      .map((e) => e.dataOrThrow(label: _label).message_stream)
      .map((e) => (e.first as MessageModel).toEntity);

  Future<ChatFetchResult> fetch(String friendId) => _remoteApiService
      .request(GMessagesFetchReq((b) => b.vars.id = friendId))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label))
      .then(
        (v) => (
          profile: (v.user_by_pk! as UserModel).toEntity,
          messages: v.message.map((e) => (e as MessageModel).toEntity),
        ),
      );

  Future<void> sendMessage(ChatMessage message) => _remoteApiService
      .request(
        GMessageCreateReq((b) => b.vars
          ..object = message.object
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

  static const _label = 'Chat';
}
