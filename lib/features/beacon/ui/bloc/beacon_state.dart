import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/beacon.dart';

part 'beacon_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BeaconState with _$BeaconState, StateFetchMixin {
  const factory BeaconState({
    @Default([]) List<Beacon> beacons,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _BeaconState;

  const BeaconState._();

  BeaconState setLoading() => copyWith(status: FetchStatus.isLoading);

  BeaconState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
