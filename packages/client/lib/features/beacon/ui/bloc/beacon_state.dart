import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'beacon_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BeaconState with _$BeaconState, StateFetchMixin {
  const factory BeaconState({
    @Default('') String userId,
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
