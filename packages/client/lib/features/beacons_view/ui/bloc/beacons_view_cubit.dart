import 'package:get_it/get_it.dart';

import 'package:tentura/features/beacon/data/repository/beacon_repository.dart';

import 'beacons_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'beacons_view_state.dart';

class BeaconsViewCubit extends Cubit<BeaconsViewState> {
  BeaconsViewCubit({
    required bool isMine,
    required String profileId,
    BeaconRepository? beaconRepository,
  }) : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),
       super(
         BeaconsViewState(profileId: profileId, isMine: isMine, beacons: []),
       ) {
    fetch();
  }

  final BeaconRepository _beaconRepository;

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final beacons = await _beaconRepository.fetchBeaconsByUserId(
        state.profileId,
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
}
