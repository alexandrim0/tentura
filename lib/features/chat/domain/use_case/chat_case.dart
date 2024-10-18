import 'package:injectable/injectable.dart';

import '../../data/repository/chat_repository.dart';

@lazySingleton
class ChatCase {
  ChatCase(this._chatRepository);

  final ChatRepository _chatRepository;

  Future<void> sendMessage(String message) =>
      _chatRepository.sendMessage(message);
}
