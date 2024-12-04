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
    required String friendId,
    ChatRepository? chatRepository,
  })  : _chatRepository = chatRepository ?? GetIt.I<ChatRepository>(),
        super(ChatState(
          me: me,
          messages: [],
          friend: Profile(
            id: friendId,
            title: '...',
          ),
          cursor: DateTime.timestamp(),
          status: FetchStatus.isLoading,
        )) {
    fetch();
  }

  final ChatRepository _chatRepository;

  late final _updates =
      _chatRepository.watchUpdates(state.cursor).where(_filterMessages).listen(
    (message) {
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
    },
    cancelOnError: false,
    onError: (Object e) => emit(state.setError(e)),
  );

  @override
  Future<void> close() async {
    await _updates.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    emit(state.setLoading());
    try {
      final fetchResult = await _chatRepository.fetch(state.friend.id);
      emit(state.copyWith(
        friend: fetchResult.profile,
      ));
      final messages = fetchResult.messages.where(_filterMessages).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(ChatState(
        me: state.me,
        friend: state.friend,
        messages: messages,
        cursor:
            messages.isEmpty ? DateTime.timestamp() : messages.last.updatedAt,
      ));
      _updates.resume();
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> onSendPressed(String text) async {
    try {
      await _chatRepository.sendMessage(emptyMessage.copyWith(
        sender: state.friend.id,
        content: text.trim(),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  // TBD: implement
  Future<void> onMessageShown(ChatMessage message) async {
    print('Seen message id: ${message.id}');
  }

  // Future<void> onMessageVisibilityChanged(
  //   ChatMessage message,
  //   bool isVisible,
  // ) async {
  //   if (kDebugMode) print(message);
  //   if (!isVisible) return;
  //   if (message.status != Status.sent) return;
  //   if (message.author.id == state.me.id) return;
  //   try {
  //     await _chatRepository.setMessageSeen(message.remoteId!);
  //   } catch (e) {
  //     emit(state.setError(e));
  //   }
  // }

  Future<void> onEndReached() async {
    if (kDebugMode) print('End riched');
  }

  bool _filterMessages(ChatMessage message) =>
      message.reciever == state.friend.id || message.sender == state.friend.id;
}
