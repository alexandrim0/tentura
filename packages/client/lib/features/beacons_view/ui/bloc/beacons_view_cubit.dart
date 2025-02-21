import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';

import '../../data/repository/beacons_repository.dart';
import 'beacons_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'beacons_view_state.dart';

class BeaconsViewCubit extends Cubit<BeaconsViewState> {
  BeaconsViewCubit({
    required bool isMine,
    required String profileId,
    BeaconsRepository? beaconsRepository,
  }) : _beaconsRepository = beaconsRepository ?? GetIt.I<BeaconsRepository>(),
       super(
         BeaconsViewState(profileId: profileId, isMine: isMine, beacons: []),
       ) {
    fetch();
  }

  final BeaconsRepository _beaconsRepository;

  void showProfile(String id) => emit(
    state.copyWith(status: StateIsNavigating('$kPathProfileView?id=$id')),
  );

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final beacons = await _beaconsRepository.fetchBeaconsByUserId(
        id: state.profileId,
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
