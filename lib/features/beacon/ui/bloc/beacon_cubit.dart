import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/use_case/beacon_case.dart';
import 'beacon_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'beacon_state.dart';

@lazySingleton
class BeaconCubit extends Cubit<BeaconState> {
  BeaconCubit(this._beaconCase) : super(const BeaconState()) {
    _authChanges.resume();
    _beaconChanges.resume();
  }

  final BeaconCase _beaconCase;

  late final _authChanges = _beaconCase.currentAccountChanges.listen(
    (userId) async {
      emit(BeaconState(
        beacons: [],
        userId: userId,
        status: FetchStatus.isLoading,
      ));
      if (userId.isNotEmpty) await fetch();
    },
    cancelOnError: false,
  );

  late final _beaconChanges = _beaconCase.beaconChanges.listen(
    (event) => switch (event) {
      final RepositoryEventCreate<Beacon> entity => emit(state.copyWith(
          beacons: state.beacons..add(entity.value),
          status: FetchStatus.isSuccess,
        )),
      final RepositoryEventUpdate<Beacon> entity => emit(state.copyWith(
          beacons: state.beacons
            ..removeWhere((e) => e.id == entity.id)
            ..add(entity.value),
          status: FetchStatus.isSuccess,
        )),
      final RepositoryEventDelete<Beacon> entity => emit(state.copyWith(
          beacons: state.beacons..removeWhere((e) => e.id == entity.id),
          status: FetchStatus.isSuccess,
        )),
    },
    cancelOnError: false,
    onError: (Object e) => emit(state.setError(e)),
  );

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    await _beaconChanges.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    emit(state.setLoading());
    try {
      final beacons = await _beaconCase.fetchBeaconsByUserId(state.userId);
      emit(state.copyWith(
        beacons: beacons.toList(),
        status: FetchStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> delete(String beaconId) async {
    emit(state.setLoading());
    try {
      await _beaconCase.delete(beaconId);
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> toggleEnabled(String beaconId) async {
    emit(state.setLoading());
    try {
      await _beaconCase.setEnabled(
        !state.beacons.singleWhere((e) => e.id == beaconId).isEnabled,
        id: beaconId,
      );
    } catch (e) {
      emit(state.setError(e));
    }
  }
}
