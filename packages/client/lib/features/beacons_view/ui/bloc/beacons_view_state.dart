import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

export 'package:tentura/ui/bloc/state_base.dart';

part 'beacons_view_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BeaconsViewState extends StateBase with _$BeaconsViewState {
  const factory BeaconsViewState({
    required bool isMine,
    required String profileId,
    required List<Beacon> beacons,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _BeaconsViewState;

  const BeaconsViewState._();
}
