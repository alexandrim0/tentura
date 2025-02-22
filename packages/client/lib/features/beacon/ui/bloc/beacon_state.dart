import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'beacon_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BeaconState extends StateBase with _$BeaconState {
  const factory BeaconState({
    @Default(0) int limit,
    @Default(0) int offset,
    @Default(false) bool isMine,
    @Default('') String profileId,
    @Default([]) List<Beacon> beacons,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _BeaconState;

  const BeaconState._();
}
