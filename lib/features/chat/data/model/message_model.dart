import '../../domain/entity/chat_message.dart';
import '../gql/_g/message_model.data.gql.dart';

extension type const MessageModel(GMessageModel i) implements GMessageModel {
  ChatMessage get toEntity => ChatMessage(
        id: id.value,
        object: object,
        subject: subject,
        content: message,
        delivered: delivered,
        createdAt: created_at,
        updatedAt: updated_at,
      );
}
