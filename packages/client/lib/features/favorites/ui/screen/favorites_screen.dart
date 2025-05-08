import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';

import '../bloc/favorites_cubit.dart';

@RoutePage()
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = GetIt.I<FavoritesCubit>();
    final l10n = L10n.of(context)!;
    return SafeArea(
      minimum: kPaddingH,
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: favoritesCubit,
        buildWhen: (_, c) => c.isSuccess,
        builder: (context, state) {
          return state.isLoading
              // Loading state
              ? const Center(child: CircularProgressIndicator.adaptive())
              : RefreshIndicator.adaptive(
                onRefresh: favoritesCubit.fetch,
                child:
                    state.beacons.isEmpty
                        // Empty state
                        ? Center(
                          child: Text(
                            l10n.labelNothingHere,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        )
                        // Beacons list
                        : ListView.separated(
                          key: const PageStorageKey('FavoritesListView'),
                          itemCount: state.beacons.length,
                          separatorBuilder: separatorBuilder,
                          itemBuilder: (_, i) {
                            final beacon = state.beacons[i];
                            return Padding(
                              padding: kPaddingV,
                              child: BeaconTile(
                                key: ValueKey(beacon),
                                beacon: beacon,
                                isMine: false,
                              ),
                            );
                          },
                        ),
              );
        },
      ),
    );
  }
}
