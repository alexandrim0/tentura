import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'friends_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class FriendsState with _$FriendsState, StateFetchMixin {
  const factory FriendsState({
    @Default({}) Map<String, Profile> friends,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _FriendsState;

  const FriendsState._();

  FriendsState setLoading() => copyWith(status: FetchStatus.isLoading);

  FriendsState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
