import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/state_base.dart';

export 'package:tentura/ui/bloc/state_base.dart';

part 'favorites_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class FavoritesState extends StateBase with _$FavoritesState {
  const factory FavoritesState({
    @Default('') String userId,
    @Default([]) List<Beacon> beacons,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _FavoritesState;

  const FavoritesState._();
}
