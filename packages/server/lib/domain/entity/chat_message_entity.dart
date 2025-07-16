import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_entity.freezed.dart';

@freezed
abstract class ChatMessageEntity with _$ChatMessageEntity {
  const factory ChatMessageEntity({
    required String id,
    required String message,
    required String subjectId,
    required String objectId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDelivered,
  }) = _ChatMessageEntity;

  const ChatMessageEntity._();

  Map<String, Object> get asJson => {
    'id': id,
    'message': message,
    'subject_id': subjectId,
    'object_id': objectId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'is_delivered': isDelivered,
  };
}
