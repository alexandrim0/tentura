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

  ChatMessageEntity._();
}
