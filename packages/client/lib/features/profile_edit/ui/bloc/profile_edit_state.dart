import 'package:tentura/domain/entity/image_entity.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'profile_edit_state.freezed.dart';

@freezed
abstract class ProfileEditState extends StateBase with _$ProfileEditState {
  const factory ProfileEditState({
    required Profile original,
    required String title,
    required String description,
    ImageEntity? image,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _ProfileEditState;

  const ProfileEditState._();

  bool get hasImage => image != null;

  bool get hasNoImage => image == null;

  bool get canAddImage =>
      image == null || (original.hasNoAvatar && image == null);

  bool get hasChanges =>
      image != null ||
      original.title != title ||
      original.description != description;

  bool get hasNoChanges => !hasChanges;
}
