import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/profile_repository.dart';
import 'profile_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'profile_state.dart';

/// Global Cubit
@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(const ProfileState()) {
    _authChanges = authRepository.currentAccountChanges().listen(
          _onAuthChanges,
          cancelOnError: false,
        );
  }

  final ProfileRepository _profileRepository;

  StreamSubscription<String>? _authChanges;

  @disposeMethod
  Future<void> dispose() async {
    await _authChanges?.cancel();
    return super.close();
  }

  void showProfileEditor() => emit(state.copyWith(
        status: const StateIsNavigating(kPathProfileEdit),
      ));

  void showRating() => emit(state.copyWith(
        status: const StateIsNavigating(kPathRating),
      ));

  void showGraph(String focus) => emit(state.copyWith(
        status: StateIsNavigating('$kPathGraph?focus=$focus'),
      ));

  Future<void> fetch() async {
    if (state.profile.id.isEmpty) return;
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final profile = await _profileRepository.fetch(state.profile.id);
      emit(ProfileState(
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> update(Profile profile) async {
    if (profile == state.profile) return;
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      await _profileRepository.update(profile);
      emit(ProfileState(
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> delete() async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      await _profileRepository.delete(state.profile.id);
      emit(const ProfileState());
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> putAvatarImage(Uint8List image) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      await _profileRepository.putAvatarImage(image);
      emit(ProfileState(profile: state.profile));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> _onAuthChanges(String id) async {
    emit(ProfileState(
      profile: Profile(id: id),
    ));
    if (id.isNotEmpty) await fetch();
  }
}
