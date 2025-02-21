import 'package:injectable/injectable.dart';
import 'package:tentura/domain/entity/beacon.dart';

import 'package:tentura/features/favorites/ui/bloc/favorites_cubit.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

@Singleton(as: FavoritesCubit)
class FavoritesCubitMock extends Cubit<FavoritesState>
    implements FavoritesCubit {
  FavoritesCubitMock() : super(FavoritesState(beacons: [beaconA, beaconB]));

  @override
  Stream<Beacon> get favoritesChanges async* {}

  @override
  void showProfile(String id) {}

  @override
  Future<void> fetch([String? contextName]) async {}

  @override
  Future<void> pin(Beacon beacon) async {
    throw UnimplementedError();
  }

  @override
  Future<void> unpin(Beacon beacon) async {
    throw UnimplementedError();
  }
}
