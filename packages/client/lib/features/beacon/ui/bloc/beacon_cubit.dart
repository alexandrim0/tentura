import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/beacon_repository.dart';
import 'beacon_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'beacon_state.dart';

@lazySingleton
class BeaconCubit extends Cubit<BeaconState> {
  BeaconCubit({required String profileId, BeaconRepository? beaconRepository})
    : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),

      super(BeaconState(profileId: profileId, beacons: []));

  @factoryMethod
  BeaconCubit.global(AuthRepository authRepository, this._beaconRepository)
    : super(const BeaconState(isMine: true)) {
    _authChanges = authRepository.currentAccountChanges().listen(
      _onAuthChanges,
      cancelOnError: false,
      onError: _onAuthChangesError,
    );
    _beaconChanges = _beaconRepository.changes.listen(
      _onBeaconChanges,
      cancelOnError: false,
      onError: _onBeaconChangesError,
    );
  }

  final BeaconRepository _beaconRepository;

  StreamSubscription<String>? _authChanges;

  StreamSubscription<RepositoryEvent<Beacon>>? _beaconChanges;

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges?.cancel();
    await _beaconChanges?.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final beacons = await _beaconRepository.fetchBeacons(
        profileId: state.profileId,
      );
      emit(
        state.copyWith(
          beacons: beacons.toList(),
          status: StateStatus.isSuccess,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> delete(String beaconId) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _beaconRepository.delete(beaconId);
      state.beacons.removeWhere((e) => e.id == beaconId);
      emit(state.copyWith(status: StateStatus.isSuccess));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> toggleEnabled(String beaconId) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _beaconRepository.setEnabled(
        !state.beacons.singleWhere((e) => e.id == beaconId).isEnabled,
        id: beaconId,
      );
      emit(state.copyWith(status: StateStatus.isSuccess));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> _onAuthChanges(String userId) async {
    emit(BeaconState(beacons: [], profileId: userId));
    if (userId.isNotEmpty) await fetch();
  }

  void _onAuthChangesError(Object e) =>
      emit(state.copyWith(status: StateHasError(e)));

  void _onBeaconChanges(RepositoryEvent<Beacon> event) => switch (event) {
    final RepositoryEventCreate<Beacon> entity => emit(
      BeaconState(
        beacons: state.beacons..insert(0, entity.value),
        profileId: state.profileId,
      ),
    ),
    final RepositoryEventUpdate<Beacon> entity => emit(
      BeaconState(
        beacons:
            state.beacons
              ..removeWhere((e) => e.id == entity.id)
              ..add(entity.value),
        profileId: state.profileId,
      ),
    ),
    final RepositoryEventDelete<Beacon> entity => emit(
      BeaconState(
        beacons: state.beacons..removeWhere((e) => e.id == entity.id),
        profileId: state.profileId,
      ),
    ),
    final RepositoryEventFetch<Beacon> _ => null,
  };

  void _onBeaconChangesError(Object e) =>
      emit(state.copyWith(status: StateHasError(e)));
}
