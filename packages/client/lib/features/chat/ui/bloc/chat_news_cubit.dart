import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/enum.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/chat_repository.dart';
import '../../domain/entity/chat_message_entity.dart';
import 'chat_news_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'chat_news_state.dart';

/// Global Cubit
@singleton
class ChatNewsCubit extends Cubit<ChatNewsState> {
  ChatNewsCubit(
    this._authRepository,
    this._chatRepository,
  ) : super(
        ChatNewsState(
          myId: '',
          messages: {},
          lastUpdate: DateTime.timestamp(),
        ),
      ) {
    _authChanges.resume();
  }

  final AuthRepository _authRepository;

  final ChatRepository _chatRepository;

  final _messagesUpdatesController =
      StreamController<ChatMessageEntity>.broadcast();

  late final _authChanges = _authRepository.currentAccountChanges().listen(
    _onAuthChanges,
    cancelOnError: false,
    onError: (Object e) => emit(state.copyWith(status: StateHasError(e))),
  );

  StreamSubscription<Iterable<ChatMessageEntity>>? _messagesUpdatesSubscription;

  Stream<ChatMessageEntity> get updates => _messagesUpdatesController.stream;

  @override
  Future<void> close() async {
    await _authChanges.cancel();
    await _messagesUpdatesSubscription?.cancel();
    await _messagesUpdatesController.close();
    return super.close();
  }

  //
  //
  Future<void> _onAuthChanges(String userId) async {
    if (userId.isEmpty) {
      // User logged out
      emit(
        ChatNewsState(
          myId: '',
          messages: {},
          lastUpdate: DateTime.timestamp(),
        ),
      );
      await _messagesUpdatesSubscription?.cancel();
      _messagesUpdatesSubscription = null;
    } else {
      // User logged in
      emit(
        ChatNewsState(
          myId: userId,
          messages: {},
          lastUpdate: DateTime.timestamp(),
          status: StateStatus.isLoading,
        ),
      );
      try {
        await _chatRepository.syncMessagesFor(userId: userId);

        (await _chatRepository.getAllNewMessagesFor(
          userId: userId,
        )).forEach(_updateStateWithMessage);

        await _listenUpdates();
      } catch (e) {
        emit(state.copyWith(status: StateHasError(e)));
      }
      emit(state.copyWith(status: StateStatus.isSuccess));
    }
  }

  Future<void> _listenUpdates() async {
    final cursor = await _chatRepository.getLastUpdatedMessageTimestamp(
      userId: state.myId,
    );
    _messagesUpdatesSubscription = _chatRepository
        .watchUpdates(fromMoment: cursor)
        .listen(
          _onMessagesUpdate,
          cancelOnError: true,
          onError: (Object e) {
            emit(state.copyWith(status: StateHasError(e)));
            _listenUpdates();
          },
        );
  }

  //
  //
  Future<void> _onMessagesUpdate(Iterable<ChatMessageEntity> messages) async {
    if (messages.isEmpty) return;

    for (final message in messages) {
      _messagesUpdatesController.add(message);
      _updateStateWithMessage(message);
    }
    emit(state.copyWith(lastUpdate: DateTime.timestamp()));
    await _chatRepository.saveMessages(messages: messages);
  }

  //
  //
  void _updateStateWithMessage(ChatMessageEntity message) {
    switch (message.status) {
      case ChatMessageStatus.seen:
        state.messages[message.sender]?.removeWhere((e) => e.id == message.id);

      case ChatMessageStatus.sent:
        if (state.messages.containsKey(message.sender)) {
          final messagesOfSender = state.messages[message.sender]!;
          final index = messagesOfSender.indexWhere((e) => e.id == message.id);
          index < 0
              ? messagesOfSender.add(message)
              : messagesOfSender[index] = message;
        } else {
          state.messages[message.sender] = [message];
        }

      // ignore: no_default_cases //
      default:
    }
  }
}
