import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/data/repository/beacon_repository.dart';
import 'package:tentura/features/like/data/repository/like_remote_repository.dart';
import 'package:tentura/features/profile_view/data/repository/profile_view_repository.dart';

import 'profile_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'profile_view_state.dart';

class ProfileViewCubit extends Cubit<ProfileViewState> {
  ProfileViewCubit({
    required String id,
    BeaconRepository? beaconRepository,
    LikeRemoteRepository? likeRemoteRepository,
    ProfileViewRepository? profileViewRepository,
  })  : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),
        _likeRemoteRepository =
            likeRemoteRepository ?? GetIt.I<LikeRemoteRepository>(),
        _profileViewRepository =
            profileViewRepository ?? GetIt.I<ProfileViewRepository>(),
        super(ProfileViewState(
          profile: Profile(id: id),
        )) {
    fetchProfile();
  }

  final BeaconRepository _beaconRepository;

  final LikeRemoteRepository _likeRemoteRepository;

  final ProfileViewRepository _profileViewRepository;

  void showGraph(String focus) => emit(state.copyWith(
        status: StateIsNavigating('$kPathGraph?focus=$focus'),
      ));

  Future<void> fetchProfile([int limit = 3]) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final (:profile, :beacons) = await _profileViewRepository.fetchByUserId(
        state.profile.id,
        limit: limit,
      );
      emit(state.copyWith(
        profile: profile,
        beacons: beacons.toList(),
        hasReachedMax: beacons.length < limit,
        status: StateStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> fetchBeacons() async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final beacons =
          await _beaconRepository.fetchBeaconsByUserId(state.profile.id);
      emit(state.copyWith(
        hasReachedMax: true,
        profile: state.profile,
        beacons: beacons.toList(),
        status: StateStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> fetchMore() =>
      state.hasNotReachedMax ? fetchBeacons() : fetchProfile();

  Future<void> addFriend() async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      emit(state.copyWith(
        profile: await _likeRemoteRepository.setLike(
          state.profile,
          amount: 1,
        ),
        status: StateStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> removeFriend() async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      emit(state.copyWith(
        profile: await _likeRemoteRepository.setLike(
          state.profile,
          amount: 0,
        ),
        status: StateStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }
}
