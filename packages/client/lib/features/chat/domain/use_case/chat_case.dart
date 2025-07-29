import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/auth/domain/use_case/auth_case.dart';

import '../../data/repository/chat_local_repository.dart';
import '../../data/repository/chat_remote_repository.dart';
import '../entity/chat_message_entity.dart';

@singleton
class ChatCase {
  ChatCase(
    this._authCase,
    this._chatLocalRepository,
    this._chatRemoteRepository,
  );

  final AuthCase _authCase;

  final ChatLocalRepository _chatLocalRepository;

  final ChatRemoteRepository _chatRemoteRepository;

  Stream<String> get authChanges => _authCase.currentAccountChanges();

  ///
  Stream<Iterable<ChatMessageEntity>> watchRemoteUpdates({
    required DateTime fromMoment,
    int batchSize = 10,
  }) => _chatRemoteRepository.watchUpdates(
    fromMoment: fromMoment,
    batchSize: batchSize,
  );

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
    objectId: objectId,
    subjectId: subjectId,
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
  }) => _chatLocalRepository.getLastUpdatedMessageTimestamp(
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
