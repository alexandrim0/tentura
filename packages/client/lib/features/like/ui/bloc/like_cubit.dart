import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/likable.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';
import 'package:tentura/features/like/data/repository/like_remote_repository.dart';

import 'like_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'like_state.dart';

/// Global Cubit
@lazySingleton
class LikeCubit extends Cubit<LikeState> {
  LikeCubit(
    this._authRepository,
    this._likeRemoteRepository,
  ) : super(LikeState(
          likes: {},
          updatedAt: DateTime.timestamp(),
        )) {
    _authChanges.resume();
    _likeChanges.resume();
  }

  final AuthRepository _authRepository;

  final LikeRemoteRepository _likeRemoteRepository;

  late final _authChanges = _authRepository.currentAccountChanges().listen(
        (id) => emit(LikeState(
          likes: {},
          updatedAt: DateTime.timestamp(),
        )),
        cancelOnError: false,
      );

  late final _likeChanges = _likeRemoteRepository.changes.listen(
    (e) {
      state.likes[e.id] = e.value.votes;
      emit(state.copyWith(
        updatedAt: DateTime.timestamp(),
      ));
    },
    cancelOnError: false,
  );

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    await _likeChanges.cancel();
    return super.close();
  }

  Future<void> incrementLike(Likable entity) async {
    try {
      await _likeRemoteRepository.setLike(
        entity,
        amount: (state.likes[entity.id] ?? entity.votes) + 1,
      );
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> decrementLike(Likable entity) async {
    try {
      await _likeRemoteRepository.setLike(
        entity,
        amount: (state.likes[entity.id] ?? entity.votes) - 1,
      );
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }
}
