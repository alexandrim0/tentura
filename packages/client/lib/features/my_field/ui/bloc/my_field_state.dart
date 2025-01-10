import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

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
