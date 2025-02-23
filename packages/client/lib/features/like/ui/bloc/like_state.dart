import 'package:tentura/ui/bloc/state_base.dart';

export 'package:tentura/ui/bloc/state_base.dart';

part 'like_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class LikeState extends StateBase with _$LikeState {
  const factory LikeState({
    required DateTime updatedAt,
    @Default({}) Map<String, int> likes,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _LikeState;

  const LikeState._();
}
