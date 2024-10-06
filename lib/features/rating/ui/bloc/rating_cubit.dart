import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:tentura/ui/bloc/state_base.dart';

import '../../data/rating_repository.dart';
import '../../domain/entity/user_rating.dart';
import 'rating_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit({
    RatingRepository? repository,
  })  : _repository = repository ?? GetIt.I<RatingRepository>(),
        super(const RatingState()) {
    fetch();
  }

  final RatingRepository _repository;

  List<UserRating> _items = [];

  Future<void> fetch([String? contextName]) async {
    emit(state.setLoading());
    try {
      final rating = await _repository.fetch(
        context: contextName ?? state.context,
      );
      _items = rating.toList(growable: false);
      emit(state.copyWith(
        status: FetchStatus.isSuccess,
        items: _items,
      ));
      _sort();
    } catch (e) {
      emit(state.setError(e));
    }
  }

  void toggleSortingByAsc() {
    emit(state.copyWith(isSortedByAsc: !state.isSortedByAsc));
    _sort();
  }

  void toggleSortingByEgo() {
    emit(state.copyWith(isSortedByEgo: !state.isSortedByEgo));
    _sort();
  }

  void setSearchFilter(String filter) => emit(state.copyWith(
        searchFilter: filter,
        items: _items
            .where((e) =>
                e.profile.title.toLowerCase().contains(filter.toLowerCase()))
            .toList(),
      ));

  void clearSearchFilter() => emit(state.copyWith(
        searchFilter: '',
        items: _items,
      ));

  void _sort() {
    if (state.isSortedByEgo) {
      state.items.sort((a, b) {
        final c = state.isSortedByAsc
            ? a.egoScore - b.egoScore
            : b.egoScore - a.egoScore;
        return (c * 10000).toInt();
      });
    } else {
      state.items.sort((a, b) {
        final c = state.isSortedByAsc
            ? a.userScore - b.userScore
            : b.userScore - a.userScore;
        return (c * 10000).toInt();
      });
    }
  }
}
