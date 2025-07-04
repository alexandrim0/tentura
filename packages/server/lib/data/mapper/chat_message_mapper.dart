import 'package:tentura_server/domain/entity/chat_message_entity.dart';

import '../database/tentura_db.dart';

mixin ChatMessageMapper {
  ChatMessageEntity messageModelToEntity(Message model) => ChatMessageEntity(
    id: model.id.uuid,
    subjectId: model.subject,
    objectId: model.object,
    message: model.message,
    createdAt: model.createdAt.dateTime,
    updatedAt: model.updatedAt.dateTime,
    isDelivered: model.delivered,
  );
}
