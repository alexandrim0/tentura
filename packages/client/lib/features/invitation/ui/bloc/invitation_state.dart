import 'package:tentura/domain/entity/invitation_entity.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'invitation_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class InvitationState extends StateBase with _$InvitationState {
  const factory InvitationState({
    @Default(false) bool hasReachedMax,
    @Default([]) List<InvitationEntity> invitations,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _InvitationState;

  const InvitationState._();
}
