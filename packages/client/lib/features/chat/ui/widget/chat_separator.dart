import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../../domain/entity/chat_message.dart';

class ChatSeparator extends StatelessWidget {
  const ChatSeparator({
    required this.currentMessage,
    required this.nextMessage,
    super.key,
  });

  final ChatMessage currentMessage;
  final ChatMessage nextMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (currentMessage.createdAt.day == nextMessage.createdAt.day) {
      return const SizedBox(height: kSpacingSmall);
    }
    return Padding(
      padding: kPaddingAllS,
      child: Text(
        currentMessage.createdAt.day == DateTime.timestamp().day
            ? AppLocalizations.of(context)!.chatLabelToday
            : dateFormatYMD(currentMessage.createdAt),
        style: theme.textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
