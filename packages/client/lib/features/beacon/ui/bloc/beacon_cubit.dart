import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/beacon_repository.dart';
import 'beacon_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'beacon_state.dart';

/// Global Cubit
@lazySingleton
class BeaconCubit extends Cubit<BeaconState> {
  BeaconCubit(
    this._authRepository,
    this._beaconRepository,
  ) : super(const BeaconState()) {
    _authChanges.resume();
    _beaconChanges.resume();
  }

  final AuthRepository _authRepository;

  final BeaconRepository _beaconRepository;

  late final _authChanges = _authRepository.currentAccountChanges().listen(
    (userId) async {
      emit(BeaconState(
        beacons: [],
        userId: userId,
      ));
      if (userId.isNotEmpty) await fetch();
    },
    cancelOnError: false,
  );

  late final _beaconChanges = _beaconRepository.changes.listen(
    (event) => switch (event) {
      final RepositoryEventCreate<Beacon> entity => emit(BeaconState(
          beacons: state.beacons..insert(0, entity.value),
          userId: state.userId,
        )),
      final RepositoryEventUpdate<Beacon> entity => emit(BeaconState(
          beacons: state.beacons
            ..removeWhere((e) => e.id == entity.id)
            ..add(entity.value),
          userId: state.userId,
        )),
      final RepositoryEventDelete<Beacon> entity => emit(BeaconState(
          beacons: state.beacons..removeWhere((e) => e.id == entity.id),
          userId: state.userId,
        )),
      final RepositoryEventFetch<Beacon> _ => null,
    },
    cancelOnError: false,
    onError: (Object e) => emit(state.copyWith(
      status: StateHasError(e),
    )),
  );

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    await _beaconChanges.cancel();
    return super.close();
  }

  void showBeaconCreate() => emit(state.copyWith(
        status: const StateIsNavigating(kPathBeaconNew),
      ));

  void showBeacon(String id) => emit(state.copyWith(
        status: StateIsNavigating('$kPathBeaconView?id=$id'),
      ));

  void showGraph(String focus) => emit(state.copyWith(
        status: StateIsNavigating('$kPathGraph?focus=$focus'),
      ));

  Future<void> fetch() async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final beacons =
          await _beaconRepository.fetchBeaconsByUserId(state.userId);
      emit(state.copyWith(
        beacons: beacons.toList(),
        status: StateStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> create({
    required Beacon beacon,
    Uint8List? image,
  }) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final result = await _beaconRepository.create(beacon.copyWith(
        hasPicture: image != null,
      ));
      if (image != null && image.isNotEmpty) {
        await _beaconRepository.putBeaconImage(
          beaconId: result.id,
          image: image,
        );
      }
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> delete(String beaconId) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      await _beaconRepository.delete(beaconId);
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> toggleEnabled(String beaconId) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      await _beaconRepository.setEnabled(
        !state.beacons.singleWhere((e) => e.id == beaconId).isEnabled,
        id: beaconId,
      );
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }
}
