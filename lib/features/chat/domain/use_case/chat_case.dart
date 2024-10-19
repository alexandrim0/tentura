import 'package:injectable/injectable.dart';

import '../../data/repository/chat_repository.dart';
import '../entity/chat_message.dart';

@lazySingleton
class ChatCase {
  ChatCase(this._chatRepository);

  final ChatRepository _chatRepository;

  Future<ChatMessage> sendMessage(ChatMessage message) =>
      _chatRepository.sendMessage(message);
}
