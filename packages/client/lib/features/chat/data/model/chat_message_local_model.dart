import 'package:tentura/data/database/database.dart';

import '../../domain/entity/chat_message_entity.dart';

extension type const ChatMessageLocalModel(Message i) implements Message {
  ChatMessageEntity toEntity() => ChatMessageEntity(
    id: i.id,
    sender: i.subjectId,
    reciever: i.objectId,
    createdAt: i.createdAt,
    updatedAt: i.updatedAt,
    content: i.content,
    status: i.status,
  );
}
