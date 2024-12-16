import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../data/repository/chat_repository.dart';
import '../../domain/entity/chat_message.dart';
import 'chat_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required Profile me,
    required Profile friend,
    required Stream<ChatMessage> updatesStream,
    ChatRepository? chatRepository,
  })  : _updatesStream = updatesStream,
        _chatRepository = chatRepository ?? GetIt.I<ChatRepository>(),
        super(ChatState(
          me: me,
          messages: [],
          friend: friend,
          cursor: DateTime.fromMillisecondsSinceEpoch(0),
        )) {
    _fetch();
  }

  final ChatRepository _chatRepository;

  final Stream<ChatMessage> _updatesStream;

  late final _updatesSubscription = _updatesStream
      .where(
        (m) => m.reciever == state.friend.id || m.sender == state.friend.id,
      )
      .listen(
        _onMessage,
        cancelOnError: false,
        onError: (Object e) => emit(state.setError(e)),
      );

  @override
  Future<void> close() async {
    await _updatesSubscription.cancel();
    return super.close();
  }

  Future<void> onSendPressed(String text) async {
    try {
      await _chatRepository.sendMessage(emptyMessage.copyWith(
        reciever: state.friend.id,
        content: text.trim(),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> onMessageShown(ChatMessage message) async {
    if (message.sender != state.me.id) {
      await _chatRepository.setMessageSeen(messageId: message.id);
    }
  }

  // TBD
  Future<void> onChatClear() async {}

  Future<void> _fetch() async {
    emit(state.setLoading());
    try {
      final result = await _chatRepository.getChatMessagesFor(
        subjectId: state.me.id,
        objectId: state.friend.id,
      );
      final messages = result.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(state.copyWith(
        messages: messages,
        status: FetchStatus.isSuccess,
        cursor:
            messages.isEmpty ? DateTime.timestamp() : messages.last.updatedAt,
      ));
      _updatesSubscription.resume();
    } catch (e) {
      emit(state.setError(e));
    }
  }

  void _onMessage(ChatMessage message) {
    final index = state.messages.indexWhere((e) => e.id == message.id);
    if (index < 0) {
      state.messages.insert(0, message);
    } else {
      state.messages[index] = message;
    }
    emit(state.copyWith(
      cursor: message.updatedAt,
      status: FetchStatus.isSuccess,
      error: null,
    ));
  }
}
