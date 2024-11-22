// import 'package:uuid/uuid.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../data/repository/chat_repository.dart';
import '../../domain/entity/chat_message.dart';
import 'chat_state.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required Profile me,
    required String friendId,
    ChatRepository? chatRepository,
  })  : _chatRepository = chatRepository ?? GetIt.I<ChatRepository>(),
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

  final ChatRepository _chatRepository;

  // late final _uuid = const Uuid();

  late final _updates =
      _chatRepository.watchUpdates(state.cursor).where(_filterMessages).listen(
    (m) {
      final message = _mapMessage(m);
      final index = state.messages.indexWhere((e) => e.id == message.id);
      if (index < 0) {
        state.messages.add(message);
      } else {
        state.messages[index] = message;
      }
      emit(state.copyWith(
        cursor: m.updatedAt,
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
        friend: User(
          id: fetchResult.profile.id,
          firstName: fetchResult.profile.title,
          imageUrl: fetchResult.profile.imageId,
        ),
      ));
      final messages =
          fetchResult.messages.where(_filterMessages).map(_mapMessage).toList();
      emit(ChatState(
        me: state.me,
        friend: state.friend,
        messages: messages,
        cursor: messages.isEmpty
            ? DateTime.timestamp()
            : DateTime.fromMillisecondsSinceEpoch(messages.last.updatedAt!),
      ));
      _updates.resume();
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> onSendPressed(PartialText partialText) async {
    try {
      await _chatRepository.sendMessage(emptyMessage.copyWith(
        object: state.friend.id,
        content: partialText.text,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> onMessageVisibilityChanged(
    Message message,
    bool isVisible,
  ) async {
    if (kDebugMode) print(message);
    if (!isVisible) return;
    if (message.status != Status.sent) return;
    if (message.author.id == state.me.id) return;
    try {
      await _chatRepository.setMessageSeen(message.remoteId!);
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> onEndReached() async {
    if (kDebugMode) print('End riched');
  }

  bool _filterMessages(ChatMessage message) =>
      message.subject == state.friend.id || message.object == state.friend.id;

  TextMessage _mapMessage(ChatMessage message) => TextMessage(
        id: message.id,
        remoteId: message.id,
        text: message.content,
        showStatus: true,
        type: MessageType.text,
        createdAt: message.createdAt.millisecondsSinceEpoch,
        updatedAt: message.updatedAt.millisecondsSinceEpoch,
        status: message.delivered ? Status.seen : Status.sent,
        author: message.subject == state.me.id ? state.me : state.friend,
      );
}
