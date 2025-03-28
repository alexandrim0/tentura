import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState extends StateBase with _$ProfileState {
  const factory ProfileState({
    @Default(Profile()) Profile profile,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _ProfileState;

  const ProfileState._();
}
