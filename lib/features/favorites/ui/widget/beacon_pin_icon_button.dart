import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura/features/beacon/domain/entity/beacon.dart';

import '../bloc/favorites_cubit.dart';

class BeaconPinIconButton extends StatelessWidget {
  const BeaconPinIconButton({
    required this.beacon,
    super.key,
  });

  final Beacon beacon;

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = GetIt.I<FavoritesCubit>();
    return StreamBuilder<Beacon>(
      key: ValueKey(beacon),
      initialData: favoritesCubit.state.beacons.singleWhere(
        (e) => e.id == beacon.id,
        orElse: () => beacon,
      ),
      stream: favoritesCubit.favoritesChanges.where((e) => e.id == beacon.id),
      builder: (context, snapshot) => snapshot.data?.isPinned ?? false
          ? IconButton(
              icon: const Icon(Icons.star),
              onPressed: () => favoritesCubit.unpin(beacon),
            )
          : IconButton(
              icon: const Icon(Icons.star_border),
              onPressed: () => favoritesCubit.pin(beacon),
            ),
    );
  }
}
