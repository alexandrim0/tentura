import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../data/repository/chat_repository.dart';
import '../../domain/entity/chat_message_entity.dart';
import 'chat_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required Profile me,
    required Profile friend,
    required Stream<ChatMessageEntity> updatesStream,
    ChatRepository? chatRepository,
  }) : _updatesStream = updatesStream,
       _chatRepository = chatRepository ?? GetIt.I<ChatRepository>(),
       super(
         ChatState(
           me: me,
           messages: [],
           friend: friend,
           lastUpdate: zeroAge,
         ),
       ) {
    _fetch();
  }

  final ChatRepository _chatRepository;

  final Stream<ChatMessageEntity> _updatesStream;

  late final _updatesSubscription = _updatesStream
      .where(
        (m) => m.reciever == state.friend.id || m.sender == state.friend.id,
      )
      .listen(
        _onMessage,
        cancelOnError: false,
        onError: (Object e) => emit(state.copyWith(status: StateHasError(e))),
      );

  @override
  Future<void> close() async {
    await _updatesSubscription.cancel();
    return super.close();
  }

  //
  //
  Future<void> onSendPressed(String text) async {
    try {
      await _chatRepository.sendMessage(
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
    if (message.sender != state.me.id) {
      try {
        await _chatRepository.setMessageSeen(messageId: message.id);
      } catch (e) {
        emit(state.copyWith(status: StateHasError(e)));
      }
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
      final result = await _chatRepository.getChatMessagesFor(
        subjectId: state.me.id,
        objectId: state.friend.id,
      );
      final messages = result.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(
        state.copyWith(
          messages: messages,
          status: StateStatus.isSuccess,
          lastUpdate: DateTime.timestamp(),
        ),
      );
      _updatesSubscription.resume();
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  //
  void _onMessage(ChatMessageEntity message) {
    final index = state.messages.indexWhere((e) => e.id == message.id);
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
