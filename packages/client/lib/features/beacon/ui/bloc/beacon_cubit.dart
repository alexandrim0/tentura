import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../data/repository/beacon_repository.dart';
import 'beacon_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'beacon_state.dart';

class BeaconCubit extends Cubit<BeaconState> {
  BeaconCubit({
    required bool isMine,
    required String profileId,
    BeaconRepository? beaconRepository,
  }) : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),
       super(BeaconState(profileId: profileId, isMine: isMine, beacons: []));

  final BeaconRepository _beaconRepository;

  Future<void> fetch() async {
    if (state.hasReachedLast || state.status is StateIsLoading) return;

    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final beacons = await _beaconRepository.fetchBeacons(
        offset: state.beacons.length,
        profileId: state.profileId,
      );
      emit(
        state.copyWith(
          beacons: state.beacons..addAll(beacons),
          hasReachedLast: beacons.length < kFetchWindowSize,
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
}
