import 'package:get_it/get_it.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/friends/domain/use_case/friends_case.dart';

import '../../domain/use_case/profile_view_case.dart';
import 'profile_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'profile_view_state.dart';

class ProfileViewCubit extends Cubit<ProfileViewState> {
  ProfileViewCubit({
    required String id,
    FriendsCase? friendsCase,
    ProfileViewCase? profileViewCase,
  })  : _friendsCase = friendsCase ?? GetIt.I<FriendsCase>(),
        _profileViewCase = profileViewCase ?? GetIt.I<ProfileViewCase>(),
        super(ProfileViewState(profile: Profile(id: id))) {
    fetchProfile();
  }

  final FriendsCase _friendsCase;
  final ProfileViewCase _profileViewCase;

  void showGraph(String focus) => emit(state.copyWith(
        status: StateIsNavigating('$kPathGraph?focus=$focus'),
      ));

  Future<void> fetchProfile([int limit = 3]) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final (:profile, :beacons) =
          await _profileViewCase.fetchProfileWithBeaconsByUserId(
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
          await _profileViewCase.fetchBeaconsByUserId(state.profile.id);
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
        profile: await _friendsCase.addFriend(state.profile),
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
        profile: await _friendsCase.removeFriend(state.profile),
        status: StateStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }
}
