import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tentura/domain/entity/likable.dart';
import 'package:tentura/domain/entity/repository_event.dart';

import '../../domain/use_case/like_case.dart';
import 'like_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'like_state.dart';

@lazySingleton
class LikeCubit extends Cubit<LikeState> {
  LikeCubit(this._likeCase) : super(const LikeState()) {
    _authChanges.resume();
    _likeChanges.resume();
  }

  final LikeCase _likeCase;

  late final _likeChanges = _likeCase.likeChanges.listen(
    (e) {
      state.likes[e.id] = e.value.votes;
      emit(LikeState(likes: state.likes));
    },
    cancelOnError: false,
  );

  late final _authChanges = _likeCase.currentAccountChanges.listen(
    // ignore: prefer_const_constructors
    (id) => emit(LikeState(likes: {})),
    cancelOnError: false,
  );

  Stream<RepositoryEvent<Likable>> get likeChanges => _likeCase.likeChanges;

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    await _likeChanges.cancel();
    return super.close();
  }

  Future<void> addLikeAmount({
    required Likable entity,
    required int amount,
  }) async {
    try {
      await _likeCase.addLikeAmount(
        amount: entity.votes + amount,
        entity: entity,
      );
    } catch (e) {
      emit(state.setError(e));
    }
  }
}
