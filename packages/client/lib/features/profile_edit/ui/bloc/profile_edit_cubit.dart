import 'package:get_it/get_it.dart';

import 'package:tentura/data/repository/image_repository.dart';
import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/use_case/string_input_validator.dart';
import 'package:tentura/features/auth/data/repository/auth_repository.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import 'profile_edit_state.dart';

export 'package:tentura/ui/bloc/state_base.dart';

export 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState>
    with StringInputValidator {
  ProfileEditCubit({
    required this.profile,
    AuthRepository? authRepository,
    ImageRepository? imageRepository,
    ProfileRepository? profileRepository,
  }) : _authRepository = authRepository ?? GetIt.I<AuthRepository>(),
       _imageRepository = imageRepository ?? GetIt.I<ImageRepository>(),
       _profileRepository = profileRepository ?? GetIt.I<ProfileRepository>(),
       super(
         ProfileEditState(
           title: profile.title,
           description: profile.description,
         ),
       );

  final Profile profile;

  final ImageRepository _imageRepository;

  final AuthRepository _authRepository;

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

  void clearImage() => emit(
    state.copyWith(
      status: const StateIsSuccess(),
      image: ImageEntity(imageBytes: Uint8List(0)),
    ),
  );

  Future<void> save() async {
    // TBD: have to be refactored!
    final id =
        profile.id.isEmpty
            ? await _authRepository.getCurrentAccountId()
            : profile.id;

    final profileUpdated = profile.copyWith(
      id: id,
      title: state.title,
      description: state.description,
      blurhash: state.image?.blurHash ?? '',
      imageHeight: state.image?.height ?? 0,
      imageWidth: state.image?.width ?? 0,
      hasAvatar: state.hasImage,
    );
    if (profileUpdated == profile) return;
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final image = state.image;
      if (image != null && image.imageBytes.isNotEmpty) {
        await _imageRepository.uploadImage(
          image: image.imageBytes,
          imageId: profile.id,
        );
      }
      await _profileRepository.update(profileUpdated);
      emit(state.copyWith(status: StateIsNavigating.back()));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
