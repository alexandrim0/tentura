import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/use_case/use_case_base.dart';
import 'package:tentura/data/service/remote_api_client/enum.dart';

import 'package:tentura/features/auth/data/repository/auth_local_repository.dart';

import '../../data/repository/chat_local_repository.dart';
import '../../data/repository/chat_remote_repository.dart';
import '../entity/chat_message_entity.dart';

export 'package:tentura/data/service/remote_api_client/enum.dart';

@singleton
final class ChatCase extends UseCaseBase {
  ChatCase(
    this._authLocalRepository,
    this._chatLocalRepository,
    this._chatRemoteRepository, {
    required super.env,
    required super.logger,
  });

  final AuthLocalRepository _authLocalRepository;

  final ChatLocalRepository _chatLocalRepository;

  final ChatRemoteRepository _chatRemoteRepository;

  Stream<WebSocketState> get webSocketState =>
      _chatRemoteRepository.webSocketState;

  Stream<String> get authChanges =>
      _authLocalRepository.currentAccountChanges();

  ///
  ///
  Stream<Iterable<ChatMessageEntity>> watchRemoteUpdates() =>
      _chatRemoteRepository.watchUpdates();

  ///
  ///
  void subscribeToUpdates({
    required DateTime fromMoment,
    int batchSize = 10,
  }) {
    logger.d('[ChatCase] Subscribe to updates.');
    _chatRemoteRepository.subscribeToUpdates(
      fromMoment: fromMoment,
      batchSize: batchSize,
    );
  }

  ///
  ///
  Future<void> sendMessage({
    required String receiverId,
    required String content,
  }) => _chatRemoteRepository.sendMessage(
    receiverId: receiverId,
    clientId: const Uuid().v4(),
    content: content,
  );

  ///
  Future<void> setMessageSeen({
    required ChatMessageEntity message,
  }) => _chatRemoteRepository.setMessageSeen(
    message: message,
  );

  ///
  /// Get all messages for pair from local DB
  ///
  Future<Iterable<ChatMessageEntity>> getChatMessagesFor({
    required String objectId,
    required String subjectId,
  }) => _chatLocalRepository.getChatMessagesFor(
    senderId: objectId,
    receiverId: subjectId,
  );

  ///
  /// Get all unseen messages for user from local DB
  ///
  Future<Iterable<ChatMessageEntity>> getUnseenMessagesFor({
    required String userId,
  }) => _chatLocalRepository.getAllNewMessagesFor(
    userId: userId,
  );

  ///
  /// Get last updated message timestamp
  ///
  Future<DateTime> getCursor({
    required String userId,
  }) => _chatLocalRepository.getMostRecentMessageTimestamp(
    userId: userId,
  );

  //
  //
  Future<void> saveMessages({
    required Iterable<ChatMessageEntity> messages,
  }) => _chatLocalRepository.saveMessages(
    messages: messages,
  );
}
