import 'package:tentura/domain/entity/opinion.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

export 'package:tentura/ui/bloc/state_base.dart';

part 'opinion_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class OpinionState extends StateBase with _$OpinionState {
  const factory OpinionState({
    required String objectId,
    required Profile myProfile,
    required List<Opinion> opinions,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _OpinionState;

  const OpinionState._();

  bool get hasMyOpinion =>
      opinions.indexWhere((e) => e.author.id == myProfile.id) != -1;

  bool checkIfIsMine(Opinion opinion) => opinion.author.id == myProfile.id;
}
