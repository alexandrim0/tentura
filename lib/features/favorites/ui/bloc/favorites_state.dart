import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState, StateFetchMixin {
  const factory FavoritesState({
    @Default('') String userId,
    @Default([]) List<Beacon> beacons,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _FavoritesState;

  const FavoritesState._();

  FavoritesState setLoading() => copyWith(status: FetchStatus.isLoading);

  FavoritesState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
