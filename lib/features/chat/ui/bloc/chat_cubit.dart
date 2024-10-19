import 'package:uuid/uuid.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/chat_message.dart';
import '../../domain/use_case/chat_case.dart';
import 'chat_state.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required User me,
    required User friend,
    ChatCase? chatCase,
  })  : _chatCase = chatCase ?? GetIt.I<ChatCase>(),
        super(ChatState(
          me: me,
          friend: friend,
          messages: [],
        )) {
    _updates.resume();
  }

  final ChatCase _chatCase;

  late final _updates = _chatCase.updates.listen(
    (messages) {
      for (final message in messages) {
        // state.
      }
    },
    cancelOnError: false,
  );

  @override
  Future<void> close() async {
    await _updates.cancel();
    return super.close();
  }

  Future<void> fetch() async {}

  Future<void> onSendPressed(PartialText partialText) async {
    final message = TextMessage.fromPartial(
      id: _uuid.v4(),
      author: state.me,
      partialText: partialText,
      status: Status.sending,
    );
    // state.messages.add(message);
    // final messageIndex = state.messages.lastIndexOf(message);
    emit(state.setLoading());
    try {
      final response = await _chatCase.sendMessage(emptyMessage.copyWith(
        object: state.friend.id,
        content: partialText.text,
      ));
      // state.messages[messageIndex] = message.copyWith(
      //   createdAt: response.createdAt.millisecondsSinceEpoch,
      //   status: Status.delivered,
      //   remoteId: response.id,
      // ) as TextMessage;
      emit(state.setSuccess());
    } catch (e) {
      // state.messages[messageIndex] = message.copyWith(
      //   status: Status.error,
      // ) as TextMessage;
      state.setError(e);
    }
  }

  static const _uuid = Uuid();
}
