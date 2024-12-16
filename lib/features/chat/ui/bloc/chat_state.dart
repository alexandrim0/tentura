import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/chat_message.dart';

part 'chat_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ChatState with _$ChatState, StateFetchMixin {
  const factory ChatState({
    required Profile me,
    required Profile friend,
    required DateTime cursor,
    required List<ChatMessage> messages,
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
