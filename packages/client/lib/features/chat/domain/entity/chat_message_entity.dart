import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/enum.dart';
import 'package:tentura/domain/entity/identifiable.dart';

part 'chat_message_entity.freezed.dart';

@freezed
abstract class ChatMessageEntity
    with _$ChatMessageEntity
    implements Identifiable {
  const factory ChatMessageEntity({
    required String clientId,
    required String serverId,
    required String senderId,
    required String receiverId,
    required String content,
    required ChatMessageStatus status,
    required DateTime createdAt,
    DateTime? deliveredAt,
  }) = _ChatMessageEntity;

  const ChatMessageEntity._();

  @override
  String get id => serverId;
}
