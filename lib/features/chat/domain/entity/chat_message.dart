import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/entity/identifiable.dart';

part 'chat_message.freezed.dart';

@freezed
class ChatMessage with _$ChatMessage implements Identifiable {
  const factory ChatMessage({
    required String id,
    required String object,
    required String subject,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool delivered,
  }) = _ChatMessage;

  const ChatMessage._();
}

final emptyMessage = ChatMessage(
  id: '',
  object: '',
  subject: '',
  content: '',
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
);
