import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tentura/domain/entity/likable.dart';

import '../../domain/use_case/like_case.dart';
import 'like_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'like_state.dart';

/// Global Cubit
@lazySingleton
class LikeCubit extends Cubit<LikeState> {
  LikeCubit(this._likeCase)
      : super(LikeState(
          likes: {},
          updatedAt: DateTime.timestamp(),
        )) {
    _authChanges.resume();
    _likeChanges.resume();
  }

  final LikeCase _likeCase;

  late final _authChanges = _likeCase.currentAccountChanges.listen(
    (id) => emit(LikeState(
      likes: {},
      updatedAt: DateTime.timestamp(),
    )),
    cancelOnError: false,
  );

  late final _likeChanges = _likeCase.likeChanges.listen(
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
      await _likeCase.setLikeAmount(
        amount: (state.likes[entity.id] ?? entity.votes) + 1,
        entity: entity,
      );
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> decrementLike(Likable entity) async {
    try {
      await _likeCase.setLikeAmount(
        amount: (state.likes[entity.id] ?? entity.votes) - 1,
        entity: entity,
      );
    } catch (e) {
      emit(state.setError(e));
    }
  }
}
