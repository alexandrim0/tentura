import 'package:get_it/get_it.dart';

import 'package:tentura/data/repository/image_repository.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/use_case/string_input_validator.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import 'profile_edit_state.dart';

export 'package:tentura/data/repository/image_repository.dart' show XFile;
export 'package:tentura/ui/bloc/state_base.dart';

export 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState>
    with StringInputValidator {
  ProfileEditCubit({
    required Profile profile,
    ImageRepository? imageRepository,
    ProfileRepository? profileRepository,
  }) : _imageRepository = imageRepository ?? GetIt.I<ImageRepository>(),
       _profileRepository = profileRepository ?? GetIt.I<ProfileRepository>(),
       super(
         ProfileEditState(
           original: profile,
           title: profile.title,
           description: profile.description,
         ),
       );

  final ImageRepository _imageRepository;

  final ProfileRepository _profileRepository;

  void setTitle(String value) => emit(state.copyWith(title: value));

  void setDescription(String value) => emit(state.copyWith(description: value));

  Future<void> pickImage() async {
    try {
      final image = await _imageRepository.pickImage();
      if (image != null) {
        emit(state.copyWith(image: image));
      }
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  void clearImage() =>
      emit(state.copyWith(status: const StateIsSuccess(), image: null));

  Future<void> save() async {
    if (state.hasNoChanges) {
      return;
    }
    final profileUpdated = state.original.copyWith(
      title: state.title,
      description: state.description,
      hasAvatar: state.hasImage || state.original.hasAvatar,
    );
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _profileRepository.update(
        profileUpdated,
        image: state.image,
        dropImage: state.original.hasAvatar && state.hasNoImage,
      );
      emit(state.copyWith(status: StateIsNavigating.back()));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
