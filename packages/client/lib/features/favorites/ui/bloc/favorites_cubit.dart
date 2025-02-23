import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/beacon.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';
import 'package:tentura/features/favorites/data/repository/favorites_remote_repository.dart';

import 'favorites_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'favorites_state.dart';

/// Global Cubit
@lazySingleton
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._authRepository, this._favoritesRemoteRepository)
    : super(const FavoritesState()) {
    _authChanges.resume();
    _favoritesChanges.resume();
  }

  final AuthRepository _authRepository;

  final FavoritesRemoteRepository _favoritesRemoteRepository;

  late final _authChanges = _authRepository.currentAccountChanges().listen((
    userId,
  ) async {
    emit(
      FavoritesState(
        beacons: [],
        userId: userId,
        status: StateStatus.isLoading,
      ),
    );
    if (userId.isNotEmpty) await fetch();
  }, cancelOnError: false);

  late final _favoritesChanges = _favoritesRemoteRepository.changes.listen(
    (beacon) => emit(
      state.copyWith(
        beacons:
            beacon.isPinned
                ? [beacon, ...state.beacons]
                : state.beacons.where((e) => e.id != beacon.id).toList(),
        status: StateStatus.isSuccess,
      ),
    ),
    cancelOnError: false,
  );

  Stream<Beacon> get favoritesChanges => _favoritesRemoteRepository.changes;

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    await _favoritesChanges.cancel();
    return super.close();
  }

  void showProfile(String id) => emit(
    state.copyWith(status: StateIsNavigating('$kPathProfileView?id=$id')),
  );

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      emit(
        state.copyWith(
          beacons: List.from(await _favoritesRemoteRepository.fetch()),
          status: StateStatus.isSuccess,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> pin(Beacon beacon) async {
    try {
      await _favoritesRemoteRepository.pin(beacon);
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> unpin(Beacon beacon) async {
    try {
      await _favoritesRemoteRepository.unpin(
        beacon: beacon,
        userId: state.userId,
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
