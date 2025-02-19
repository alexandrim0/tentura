import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/like/data/repository/like_remote_repository.dart';
import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import 'profile_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'profile_view_state.dart';

class ProfileViewCubit extends Cubit<ProfileViewState> {
  ProfileViewCubit({
    required String id,
    ProfileRepository? profileRepository,
    LikeRemoteRepository? likeRemoteRepository,
  }) : _profileRepository = profileRepository ?? GetIt.I<ProfileRepository>(),
       _likeRemoteRepository =
           likeRemoteRepository ?? GetIt.I<LikeRemoteRepository>(),
       super(ProfileViewState(profile: Profile(id: id))) {
    fetch();
  }

  final ProfileRepository _profileRepository;

  final LikeRemoteRepository _likeRemoteRepository;

  void showGraph() => emit(
    state.copyWith(
      status: StateIsNavigating('$kPathGraph?focus=${state.profile.id}'),
    ),
  );

  void showBeacons() => emit(
    state.copyWith(
      status: StateIsNavigating('$kPathBeaconsView?id=${state.profile.id}'),
    ),
  );

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      emit(
        state.copyWith(
          status: StateStatus.isSuccess,
          profile: await _profileRepository.fetch(state.profile.id),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> addFriend() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      emit(
        state.copyWith(
          profile: await _likeRemoteRepository.setLike(
            state.profile,
            amount: 1,
          ),
          status: StateStatus.isSuccess,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> removeFriend() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      emit(
        state.copyWith(
          profile: await _likeRemoteRepository.setLike(
            state.profile,
            amount: 0,
          ),
          status: StateStatus.isSuccess,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
