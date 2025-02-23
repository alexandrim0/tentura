import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/enum.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/chat_repository.dart';
import '../../domain/entity/chat_message.dart';
import 'chat_news_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'chat_news_state.dart';

/// Global Cubit
@lazySingleton
class ChatNewsCubit extends Cubit<ChatNewsState> {
  ChatNewsCubit(this._authRepository, this._chatRepository)
    : super(ChatNewsState(cursor: _zeroAge, messages: {}, myId: '')) {
    _authChanges.resume();
  }

  final AuthRepository _authRepository;

  final ChatRepository _chatRepository;

  final _messagesUpdatesController = StreamController<ChatMessage>.broadcast();

  late final _authChanges = _authRepository.currentAccountChanges().listen(
    _onAuthChanges,
    cancelOnError: false,
    onError: (Object e) => emit(state.copyWith(status: StateHasError(e))),
  );

  StreamSubscription<Iterable<ChatMessage>>? _messagesUpdatesSubscription;

  Stream<ChatMessage> get updates => _messagesUpdatesController.stream;

  @override
  Future<void> close() async {
    await _authChanges.cancel();
    await _messagesUpdatesSubscription?.cancel();
    await _messagesUpdatesController.close();
    return super.close();
  }

  Future<void> _onAuthChanges(String userId) async {
    if (userId.isEmpty) {
      // User logged out
      emit(ChatNewsState(cursor: _zeroAge, messages: {}, myId: userId));
      await _messagesUpdatesSubscription?.cancel();
      _messagesUpdatesSubscription = null;
    } else {
      // User logged in
      emit(state.copyWith(status: StateStatus.isLoading));
      await _chatRepository.syncMessagesFor(userId: userId);

      var oldest = _zeroAge;
      for (final message in await _chatRepository.getAllNewMessagesFor(
        objectId: userId,
      )) {
        if (message.updatedAt.isAfter(oldest)) oldest = message.updatedAt;
        _processMessage(message);
      }
      emit(
        state.copyWith(
          myId: userId,
          cursor: DateTime.timestamp(),
          status: StateStatus.isSuccess,
        ),
      );
      _messagesUpdatesSubscription = _chatRepository
          .watchUpdates(fromMoment: oldest.toUtc())
          .listen(
            _onMessagesUpdate,
            cancelOnError: false,
            onError:
                (Object e) => emit(state.copyWith(status: StateHasError(e))),
          );
    }
  }

  Future<void> _onMessagesUpdate(Iterable<ChatMessage> messages) async {
    for (final message in messages) {
      _messagesUpdatesController.add(message);
      if (message.sender != state.myId) _processMessage(message);
    }
    emit(
      ChatNewsState(
        cursor: DateTime.timestamp(),
        messages: state.messages,
        myId: state.myId,
      ),
    );
  }

  void _processMessage(ChatMessage message) {
    if (message.status == ChatMessageStatus.sent) {
      if (state.messages.containsKey(message.sender)) {
        final messagesOfSender = state.messages[message.sender]!;
        final index = messagesOfSender.indexWhere((e) => e.id == message.id);
        if (index < 0) {
          messagesOfSender.add(message);
        } else {
          messagesOfSender[index] = message;
        }
      } else {
        state.messages[message.sender] = [message];
      }
    } else if (message.status == ChatMessageStatus.seen) {
      state.messages[message.sender]?.removeWhere((e) => e.id == message.id);
    }
  }

  static final _zeroAge = DateTime.fromMillisecondsSinceEpoch(0);
}
