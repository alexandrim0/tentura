import 'package:injectable/injectable.dart';

import '../../data/repository/chat_repository.dart';
import '../entity/chat_message.dart';

@lazySingleton
class ChatCase {
  ChatCase(this._chatRepository);

  final ChatRepository _chatRepository;

  Stream<Iterable<ChatMessage>> watchUpdates({
    int batchSize = 10,
    DateTime? fromMoment,
  }) =>
      _chatRepository.watchUpdates(
        batchSize: batchSize,
        fromMoment: fromMoment,
      );

  Future<ChatMessage> sendMessage(ChatMessage message) =>
      _chatRepository.sendMessage(message);

  Future<DateTime> setMessageSeen(String id) =>
      _chatRepository.setMessageSeen(id);
}
