import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/entity/identifiable.dart';
import 'package:tentura/domain/enum.dart';

part 'chat_message.freezed.dart';

@freezed
abstract class ChatMessage with _$ChatMessage implements Identifiable {
  const factory ChatMessage({
    required String id,
    required String sender,
    required String content,
    required String reciever,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(ChatMessageStatus.init) ChatMessageStatus status,
  }) = _ChatMessage;

  const ChatMessage._();
}

final emptyMessage = ChatMessage(
  id: '',
  reciever: '',
  sender: '',
  content: '',
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
);
