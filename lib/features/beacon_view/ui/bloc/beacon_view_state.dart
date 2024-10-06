import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/domain/entity/beacon.dart';
import 'package:tentura/features/comment/domain/entity/comment.dart';
import 'package:tentura/features/profile/domain/entity/profile.dart';

part 'beacon_view_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BeaconViewState with _$BeaconViewState, StateFetchMixin {
  const factory BeaconViewState({
    required Beacon beacon,
    @Default('') String focusCommentId,
    @Default(false) bool hasReachedMax,
    @Default([]) List<Comment> comments,
    @Default(Profile()) Profile myProfile,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _BeaconViewState;

  const BeaconViewState._();

  bool get hasNotReachedMax => !hasReachedMax;

  bool get isBeaconMine => beacon.author.id == myProfile.id;
  bool get isBeaconNotMine => beacon.author.id != myProfile.id;

  bool get hasFocusedComment => focusCommentId.isNotEmpty;
  bool get hasNoFocusedComment => focusCommentId.isEmpty;

  bool checkIfCommentIsMine(Comment comment) =>
      comment.author.id == myProfile.id;

  bool checkIfCommentIsNotMine(Comment comment) =>
      comment.author.id != myProfile.id;

  BeaconViewState setLoading() => copyWith(status: FetchStatus.isLoading);

  BeaconViewState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
