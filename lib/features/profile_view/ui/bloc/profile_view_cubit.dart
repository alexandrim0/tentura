import 'package:get_it/get_it.dart';

import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

import '../../domain/use_case/profile_view_case.dart';
import 'profile_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'profile_view_state.dart';

class ProfileViewCubit extends Cubit<ProfileViewState> {
  ProfileViewCubit({
    required String id,
    ProfileViewCase? profileViewCase,
  })  : _profileViewCase = profileViewCase ?? GetIt.I<ProfileViewCase>(),
        super(ProfileViewState(profile: Profile(id: id))) {
    fetchProfile();
  }

  final ProfileViewCase _profileViewCase;

  Future<void> fetchProfile([int limit = 3]) async {
    emit(state.setLoading());
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
        status: FetchStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> fetchBeacons() async {
    emit(state.setLoading());
    try {
      final beacons =
          await _profileViewCase.fetchBeaconsByUserId(state.profile.id);
      emit(state.copyWith(
        hasReachedMax: true,
        profile: state.profile,
        beacons: beacons.toList(),
        status: FetchStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> fetchMore() =>
      state.hasNotReachedMax ? fetchBeacons() : fetchProfile();

  Future<void> addFriend() async {
    emit(state.setLoading());
    try {
      emit(state.copyWith(
        status: FetchStatus.isSuccess,
        profile: state.profile.copyWith(
          myVote: await _profileViewCase.addFriend(state.profile.id),
        ),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> removeFriend() async {
    emit(state.setLoading());
    try {
      emit(state.copyWith(
        status: FetchStatus.isSuccess,
        profile: state.profile.copyWith(
          myVote: await _profileViewCase.removeFriend(state.profile.id),
        ),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }
}
