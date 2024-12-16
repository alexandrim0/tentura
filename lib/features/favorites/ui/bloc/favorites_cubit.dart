import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/use_case/favorites_case.dart';
import 'favorites_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'favorites_state.dart';

@lazySingleton
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._favoritesCase) : super(const FavoritesState()) {
    _authChanges.resume();
    _favoritesChanges.resume();
  }

  final FavoritesCase _favoritesCase;

  late final _authChanges = _favoritesCase.currentAccountChanges.listen(
    (userId) async {
      emit(FavoritesState(
        beacons: [],
        userId: userId,
        status: FetchStatus.isLoading,
      ));
      if (userId.isNotEmpty) await fetch();
    },
    cancelOnError: false,
  );

  late final _favoritesChanges = _favoritesCase.favoritesChanges.listen(
    (beacon) => emit(state.copyWith(
      beacons: beacon.isPinned
          ? [beacon, ...state.beacons]
          : state.beacons.where((e) => e.id != beacon.id).toList(),
      status: FetchStatus.isSuccess,
    )),
    cancelOnError: false,
  );

  Stream<Beacon> get favoritesChanges => _favoritesCase.favoritesChanges;

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    await _favoritesChanges.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    emit(state.setLoading());
    try {
      emit(state.copyWith(
        beacons: List.from(await _favoritesCase.fetch()),
        status: FetchStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.setError(e.toString()));
    }
  }

  Future<void> pin(Beacon beacon) async {
    try {
      await _favoritesCase.pin(beacon);
    } catch (e) {
      emit(state.setError(e.toString()));
    }
  }

  Future<void> unpin(Beacon beacon) async {
    try {
      await _favoritesCase.unpin(
        beacon: beacon,
        userId: state.userId,
      );
    } catch (e) {
      emit(state.setError(e.toString()));
    }
  }
}
