import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:tentura/domain/entity/opinion.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/like/data/repository/like_remote_repository.dart';
import 'package:tentura/features/opinion/data/repository/opinion_repository.dart';
import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import 'profile_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'profile_view_state.dart';

typedef Ids = ({String profileId, Opinion? opinion});

class ProfileViewCubit extends Cubit<ProfileViewState> {
  static Future<Ids> checkIfIdIsOpinion(String id) async {
    if (id.startsWith('U')) {
      return (profileId: id, opinion: null);
    } else if (id.startsWith('O')) {
      final result = await GetIt.I<OpinionRepository>().fetchById(id);
      return (profileId: result.objectId, opinion: result);
    } else {
      throw Exception('Wrong id prefix [$id]');
    }
  }

  ProfileViewCubit({
    required String id,
    ProfileRepository? profileRepository,
    LikeRemoteRepository? likeRemoteRepository,
  }) : _profileRepository = profileRepository ?? GetIt.I<ProfileRepository>(),
       _likeRemoteRepository =
           likeRemoteRepository ?? GetIt.I<LikeRemoteRepository>(),
       super(_idToState(id)) {
    unawaited(fetch());
  }

  final ProfileRepository _profileRepository;

  final LikeRemoteRepository _likeRemoteRepository;

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      emit(
        state.copyWith(
          status: StateStatus.isSuccess,
          profile: await _profileRepository.fetchById(state.profile.id),
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

  static ProfileViewState _idToState(String id) => switch (id) {
    _ when id.startsWith('O') => ProfileViewState(focusOpinionId: id),
    _ when id.startsWith('U') => ProfileViewState(profile: Profile(id: id)),
    _ => ProfileViewState(status: StateHasError('Wrong id: $id')),
  };
}
