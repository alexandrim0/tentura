import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/chat_message_entity.dart';
import '../../domain/use_case/chat_case.dart';
import 'chat_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required String friendId,
    ChatCase? chatCase,
  }) : _chatCase = chatCase ?? GetIt.I<ChatCase>(),
       super(
         ChatState(
           lastUpdate: zeroAge,
           friend: Profile(id: friendId),
         ),
       ) {
    _fetch();
  }

  final ChatCase _chatCase;

  late final StreamSubscription<ChatMessageEntity> _updatesSubscription;

  @override
  Future<void> close() async {
    await _updatesSubscription.cancel();
    return super.close();
  }

  //
  //
  Future<void> onSendPressed(String text) async {
    try {
      await _chatCase.sendMessage(
        receiverId: state.friend.id,
        content: text.trim(),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  //
  Future<void> onMessageShown(ChatMessageEntity message) async {
    try {
      await _chatCase.setMessageSeen(message: message);
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  // TBD
  Future<void> onChatClear() async {}

  //
  //
  Future<void> _fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final myId = await _chatCase.getCurrentAccountId();

      _updatesSubscription = _chatCase.updates
          .expand((e) => e)
          .where(
            (m) =>
                (m.receiverId == state.friend.id && m.senderId == myId) ||
                (m.receiverId == myId && m.senderId == state.friend.id),
          )
          .listen(
            _onMessage,
            cancelOnError: false,
            onError: (Object e) =>
                emit(state.copyWith(status: StateHasError(e))),
          );

      final friendProfile = await _chatCase.fetchProfileById(state.friend.id);

      final result = await _chatCase.getChatMessagesForPair(
        receiverId: myId,
        senderId: state.friend.id,
      );
      final messages = result.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(
        ChatState(
          messages: messages,
          me: Profile(id: myId),
          friend: friendProfile,
          lastUpdate: DateTime.timestamp(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  //
  void _onMessage(ChatMessageEntity message) {
    final index = state.messages.indexWhere(
      (e) => e.serverId == message.serverId,
    );
    if (index < 0) {
      state.messages.insert(0, message);
    } else {
      state.messages[index] = message;
    }
    emit(
      state.copyWith(
        status: StateStatus.isSuccess,
        lastUpdate: DateTime.timestamp(),
      ),
    );
  }
}
