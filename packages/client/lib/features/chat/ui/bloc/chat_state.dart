import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/chat_message.dart';

part 'chat_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatState extends StateBase with _$ChatState {
  const factory ChatState({
    required Profile me,
    required Profile friend,
    required DateTime cursor,
    required List<ChatMessage> messages,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _ChatState;

  const ChatState._();
}
