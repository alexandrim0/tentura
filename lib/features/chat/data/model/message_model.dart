import 'package:tentura/domain/enum.dart';

import '../../domain/entity/chat_message.dart';
import '../gql/_g/message_model.data.gql.dart';

extension type const MessageModel(GMessageModel i) implements GMessageModel {
  ChatMessage get toEntity => ChatMessage(
        id: id.value,
        reciever: object,
        sender: subject,
        content: message,
        status: delivered ? ChatMessageStatus.seen : ChatMessageStatus.sent,
        createdAt: created_at,
        updatedAt: updated_at,
      );
}
