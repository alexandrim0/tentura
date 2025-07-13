import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/repository/message_repository.dart';

import '../entity/chat_message_entity.dart';
import '../exception.dart';

@Injectable(order: 2)
class ChatCase {
  ChatCase(this._env, this._messageRepository);

  final Env _env;

  final MessageRepository _messageRepository;

  Future<ChatMessageEntity> create({
    required String receiverId,
    required String senderId,
    required String content,
  }) => _messageRepository.create(
    subjectId: receiverId,
    objectId: senderId,
    content: content,
  );

  Future<ChatMessageEntity> markAsDelivered({
    required String messageId,
    required String receiverId,
  }) async {
    await _messageRepository.markAsDelivered(
      id: messageId,
      receiverId: receiverId,
    );
    final message = await _messageRepository.fetchById(messageId);
    return message.objectId == receiverId
        ? message
        : throw const UnauthorizedException();
  }

  Future<Object> onMessage(dynamic message) async {
    return _messageRepository.fetchById(_env.environment);
  }
}
