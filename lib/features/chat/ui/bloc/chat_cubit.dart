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
          status: FetchStatus.isLoading,
          cursor: DateTime.timestamp().subtract(const Duration(days: 1)),
          messages: [],
        )) {
    _updates.resume();
  }

  final ChatCase _chatCase;

  late final _updates =
      _chatCase.watchUpdates(batchSize: 1, fromMoment: state.cursor).listen(
    (messages) {
      state.messages.addAll(messages.map((e) => TextMessage(
            id: e.id,
            remoteId: e.id,
            text: e.content,
            createdAt: e.createdAt.millisecondsSinceEpoch,
            updatedAt: e.updatedAt.millisecondsSinceEpoch,
            status: e.delivered ? Status.seen : Status.delivered,
            author: e.id == state.me.id ? state.me : state.friend,
          )));
      emit(state.setSuccess());
    },
    cancelOnError: false,
    onError: (Object e) => emit(state.setError(e)),
  );

  @override
  Future<void> close() async {
    await _updates.cancel();
    return super.close();
  }

  Future<void> onSendPressed(PartialText partialText) async {
    final message = TextMessage.fromPartial(
      id: _uuid.v4(),
      author: state.me,
      partialText: partialText,
      status: Status.sending,
    );
    state.messages.add(message);
    final messageIndex = state.messages.lastIndexOf(message);
    emit(state.setLoading());
    try {
      final response = await _chatCase.sendMessage(emptyMessage.copyWith(
        object: state.friend.id,
        content: partialText.text,
      ));
      state.messages[messageIndex] = message.copyWith(
        createdAt: response.createdAt.millisecondsSinceEpoch,
        status: Status.delivered,
        remoteId: response.id,
      ) as TextMessage;
      emit(state.setSuccess());
    } catch (e) {
      state.messages[messageIndex] = message.copyWith(
        status: Status.error,
      ) as TextMessage;
      state.setError(e);
    }
  }

  Future<void> onMessageVisibilityChanged(
    Message message,
    bool isVisible,
  ) async {
    if (!isVisible) return;
    if (message.author == state.me) return;
    if (message.status != Status.delivered) return;
    final messageIndex =
        state.messages.lastIndexWhere((e) => e.remoteId == message.remoteId);
    emit(state.setLoading());
    final updatedAt = await _chatCase.setMessageSeen(message.remoteId!);
    state.messages[messageIndex] = message.copyWith(
      updatedAt: updatedAt.millisecondsSinceEpoch,
      status: Status.seen,
    );
    emit(state.setSuccess());
  }

  static const _uuid = Uuid();
}
