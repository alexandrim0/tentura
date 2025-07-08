import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/entity/identifiable.dart';
import 'package:tentura/domain/enum.dart';

part 'chat_message_entity.freezed.dart';

@freezed
abstract class ChatMessageEntity
    with _$ChatMessageEntity
    implements Identifiable {
  const factory ChatMessageEntity({
    required String id,
    required String sender,
    required String content,
    required String reciever,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(ChatMessageStatus.init) ChatMessageStatus status,
  }) = _ChatMessageEntity;

  const ChatMessageEntity._();
}

final emptyMessage = ChatMessageEntity(
  id: '',
  reciever: '',
  sender: '',
  content: '',
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
);
