import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:tentura/ui/bloc/state_base.dart';

part 'chat_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ChatState with _$ChatState, StateFetchMixin {
  const factory ChatState({
    required DateTime cursor,
    required List<Message> messages,
    @Default(User(id: '')) User me,
    @Default(User(id: '')) User friend,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _ChatState;

  const ChatState._();

  ChatState setLoading() => copyWith(
        status: FetchStatus.isLoading,
        error: null,
      );

  ChatState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
