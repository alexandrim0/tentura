import 'package:tentura/data/database/database.dart';

import '../../domain/entity/chat_message_entity.dart';

extension type const ChatMessageLocalModel(Message i) implements Message {
  ChatMessageEntity toEntity() => ChatMessageEntity(
    clientId: i.id,
    serverId: i.id,
    senderId: i.subjectId,
    receiverId: i.objectId,
    createdAt: i.createdAt,
    deliveredAt: i.updatedAt,
    content: i.content,
    status: i.status,
  );
}
