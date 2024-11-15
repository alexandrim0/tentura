// import 'package:uuid/uuid.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/chat_message.dart';
import '../../domain/use_case/chat_case.dart';
import 'chat_state.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required Profile me,
    required String friendId,
    ChatCase? chatCase,
  })  : _chatCase = chatCase ?? GetIt.I<ChatCase>(),
        super(ChatState(
          me: User(
            id: me.id,
            firstName: me.title,
            imageUrl: me.imageId,
          ),
          friend: User(id: friendId),
          cursor: DateTime.timestamp(),
          status: FetchStatus.isLoading,
          messages: [],
        )) {
    fetch();
  }

  final ChatCase _chatCase;

  // late final _uuid = const Uuid();

  late final _updates = _chatCase.watchUpdates(fromMoment: state.cursor).listen(
    (messages) {
      if (messages.isEmpty) return;
      final messagesFiltered = _filterMessagesByUserId(
        messages,
        state.friend.id,
      );
      if (messagesFiltered.isEmpty) return;
      final messagesConverted = _convertMessages(
        messagesFiltered,
        state.friend,
      );

      for (final message in messagesConverted) {
        final index = state.messages.indexWhere((e) => e.id == message.id);
        if (index < 0) {
          state.messages.add(message);
        } else {
          state.messages[index] = message;
        }
      }
      emit(state.copyWith(
        cursor: messagesFiltered.last.updatedAt,
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
    try {
      final fetchResult = await _chatCase.fetch(state.friend.id);
      final friend = User(
        id: fetchResult.profile.id,
        firstName: fetchResult.profile.title,
        imageUrl: fetchResult.profile.imageId,
      );
      final messagesFiltered = _filterMessagesByUserId(
        fetchResult.messages,
        friend.id,
      );

      if (messagesFiltered.isNotEmpty) {
        final messages = _convertMessages(messagesFiltered, friend).toList();
        emit(ChatState(
          me: state.me,
          friend: friend,
          messages: messages,
          cursor: messagesFiltered.last.updatedAt,
        ));
      } else {
        emit(state.copyWith(
          friend: friend,
          status: FetchStatus.isSuccess,
          error: null,
        ));
      }
      _updates.resume();
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> onSendPressed(PartialText partialText) async {
    try {
      await _chatCase.sendMessage(emptyMessage.copyWith(
        object: state.friend.id,
        content: partialText.text,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  // Future<void> onSendPressed(PartialText partialText) async {
  //   final message = TextMessage.fromPartial(
  //     id: _uuid.v4(),
  //     author: state.me,
  //     partialText: partialText,
  //     status: Status.sending,
  //   );
  //   state.messages.add(message);
  //   final messageIndex = state.messages.lastIndexOf(message);
  //   try {
  //     final response = await _chatCase.sendMessage(emptyMessage.copyWith(
  //       object: state.friend.id,
  //       content: partialText.text,
  //     ));
  //     state.messages[messageIndex] = message.copyWith(
  //       createdAt: response.createdAt.microsecondsSinceEpoch,
  //       remoteId: response.id,
  //       status: Status.sent,
  //     ) as TextMessage;
  //     emit(state.setCursor());
  //   } catch (e) {
  //     state.messages[messageIndex] = message.copyWith(
  //       status: Status.error,
  //     ) as TextMessage;
  //     emit(state.setCursor());
  //     emit(state.setError(e));
  //   }
  // }

  Future<void> onMessageVisibilityChanged(
    Message message,
    bool isVisible,
  ) async {
    if (kDebugMode) print(message);
    if (!isVisible) return;
    if (message.status != Status.sent) return;
    if (message.author.id == state.me.id) return;
    final messageIndex =
        state.messages.lastIndexWhere((e) => e.remoteId == message.remoteId);
    try {
      final updatedAt = await _chatCase.setMessageSeen(message.remoteId!);
      state.messages[messageIndex] = message.copyWith(
        updatedAt: updatedAt.millisecondsSinceEpoch,
        status: Status.seen,
      );
      emit(state.copyWith(
        cursor: updatedAt,
        status: FetchStatus.isSuccess,
        error: null,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> onEndReached() async {
    if (kDebugMode) print('End riched');
  }

  Iterable<ChatMessage> _filterMessagesByUserId(
    Iterable<ChatMessage> messages,
    String id,
  ) =>
      messages.where((e) => e.subject == id || e.object == id);

  Iterable<TextMessage> _convertMessages(
    Iterable<ChatMessage> messages,
    User friend,
  ) =>
      messages.map((e) => TextMessage(
            id: e.id,
            remoteId: e.id,
            text: e.content,
            showStatus: true,
            type: MessageType.text,
            createdAt: e.createdAt.millisecondsSinceEpoch,
            updatedAt: e.updatedAt.millisecondsSinceEpoch,
            author: e.subject == state.me.id
                ? state.me
                : e.subject == friend.id
                    ? friend
                    : const User(id: 'Unknown'),
            status: e.delivered ? Status.seen : Status.sent,
          ));
}
