import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'profile_edit_state.freezed.dart';

@freezed
class ProfileEditState extends StateBase with _$ProfileEditState {
  const factory ProfileEditState({
    ImageEntity? image,
    @Default('') String title,
    @Default('') String description,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _ProfileEditState;

  const ProfileEditState._();

  bool get hasImage => image != null;

  bool get hasNoImage => image == null;
}
