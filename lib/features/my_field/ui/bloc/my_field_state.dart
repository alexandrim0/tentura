import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/domain/entity/beacon.dart';

part 'my_field_state.freezed.dart';

@freezed
class MyFieldState with _$MyFieldState, StateFetchMixin {
  const factory MyFieldState({
    @Default('') String context,
    @Default([]) List<Beacon> beacons,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _MyFieldState;

  const MyFieldState._();

  MyFieldState setLoading() => copyWith(status: FetchStatus.isLoading);

  MyFieldState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
