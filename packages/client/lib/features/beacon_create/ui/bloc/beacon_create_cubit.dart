import 'package:get_it/get_it.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/data/repository/beacon_repository.dart';

import 'beacon_create_state.dart';

class BeaconCreateCubit extends Cubit<BeaconCreateState> {
  BeaconCreateCubit({
    BeaconRepository? beaconRepository,
  })  : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),
        super(const BeaconCreateState());

  final BeaconRepository _beaconRepository;

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
}
