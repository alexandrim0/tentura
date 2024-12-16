import 'package:tentura/data/database/database.dart';
import 'package:tentura/domain/enum.dart';

import '../../domain/entity/chat_message.dart';
import '../gql/_g/message_model.data.gql.dart';

ChatMessage toEntityFrom<T>(T m) => switch (m) {
      final Message m => ChatMessage(
          id: m.id,
          content: m.content,
          sender: m.subjectId,
          reciever: m.objectId,
          createdAt: m.createdAt,
          updatedAt: m.updatedAt,
          status: m.status,
        ),
      final GMessageModel m => ChatMessage(
          id: m.id.value,
          reciever: m.object,
          sender: m.subject,
          content: m.message,
          status: m.delivered ? ChatMessageStatus.seen : ChatMessageStatus.sent,
          createdAt: m.created_at,
          updatedAt: m.updated_at,
        ),
      _ => throw const FormatException('Can`t map to ChatMessage!'),
    };
