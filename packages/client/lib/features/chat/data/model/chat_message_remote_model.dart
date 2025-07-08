import 'package:tentura/domain/enum.dart';

import '../../domain/entity/chat_message_entity.dart';
import '../gql/_g/message_model.data.gql.dart';

extension type const ChatMessageRemoteModel(GMessageModel i)
    implements GMessageModel {
  ChatMessageEntity toEntity() => ChatMessageEntity(
    id: i.id.value,
    sender: i.subject,
    reciever: i.object,
    createdAt: i.created_at,
    updatedAt: i.updated_at,
    content: i.message,
    status: i.delivered ? ChatMessageStatus.seen : ChatMessageStatus.sent,
  );
}
