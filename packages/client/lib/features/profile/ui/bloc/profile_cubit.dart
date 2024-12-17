import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/profile_repository.dart';
import 'profile_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'profile_state.dart';

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

  Future<void> fetch() async {
    if (state.profile.id.isEmpty) return;
    emit(state.setLoading());
    try {
      final profile = await _profileRepository.fetch(state.profile.id);
      emit(ProfileState(
        profile: profile,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> update(Profile profile) async {
    if (profile == state.profile) return;
    emit(state.setLoading());
    try {
      await _profileRepository.update(profile);
      emit(ProfileState(
        profile: profile,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> delete() async {
    emit(state.setLoading());
    try {
      await _profileRepository.delete(state.profile.id);
      emit(const ProfileState());
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> putAvatarImage(Uint8List image) async {
    emit(state.setLoading());
    try {
      await _profileRepository.putAvatarImage(image);
      emit(ProfileState(profile: state.profile));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> _onAuthChanges(String id) async {
    emit(ProfileState(
      profile: Profile(id: id),
      status: FetchStatus.isLoading,
    ));
    if (id.isNotEmpty) await fetch();
  }
}
