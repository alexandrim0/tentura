import 'package:tentura/ui/bloc/state_base.dart';

export 'package:tentura/ui/bloc/state_base.dart';

part 'comment_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class CommentState extends StateBase with _$CommentState {
  const factory CommentState({
    @Default(StateIsSuccess()) StateStatus status,
  }) = _CommentState;

  const CommentState._();
}
