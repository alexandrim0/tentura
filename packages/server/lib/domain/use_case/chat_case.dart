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
    objectId: receiverId,
    subjectId: senderId,
    content: content,
  );

  Future<ChatMessageEntity> markAsDelivered({
    required String messageId,
    required String receiverId,
  }) async {
    await _messageRepository.markAsDelivered(
      id: messageId,
      objectId: receiverId,
    );

    final message = await _messageRepository.fetchById(messageId);
    if (message == null) {
      throw const IdNotFoundException();
    }
    if (message.objectId != receiverId) {
      throw const UnauthorizedException();
    }
    return message;
  }

  Future<Object?> onMessage(dynamic message) async {
    print('${message.runtimeType} [$message]');
    return _env.environment;
  }
}
