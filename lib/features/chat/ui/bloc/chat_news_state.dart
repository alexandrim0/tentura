import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/chat_message.dart';

part 'chat_news_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ChatNewsState with _$ChatNewsState, StateFetchMixin {
  const factory ChatNewsState({
    required String myId,
    required DateTime cursor,
    required int countNewTotal,
    required Map<String, List<ChatMessage>> messages,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _ChatNewsState;

  const ChatNewsState._();

  ChatNewsState setLoading() => copyWith(
        status: FetchStatus.isLoading,
        error: null,
      );

  ChatNewsState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
