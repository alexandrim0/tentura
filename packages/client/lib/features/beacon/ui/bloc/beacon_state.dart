import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'beacon_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BeaconState extends StateBase with _$BeaconState {
  const factory BeaconState({
    required bool isMine,
    required String profileId,
    required List<Beacon> beacons,
    @Default(false) bool hasReachedLast,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _BeaconState;

  const BeaconState._();
}
