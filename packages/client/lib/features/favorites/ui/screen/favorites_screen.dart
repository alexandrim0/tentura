import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';

import '../bloc/favorites_cubit.dart';

@RoutePage()
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = GetIt.I<FavoritesCubit>();
    return SafeArea(
      minimum: kPaddingH,
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: favoritesCubit,
        buildWhen: (p, c) => c.isSuccess,
        builder: (context, state) {
          return state.isLoading
              // Loading state
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : RefreshIndicator.adaptive(
                  onRefresh: favoritesCubit.fetch,
                  child: state.beacons.isEmpty

                      // Empty state
                      ? CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'There is nothing here yet',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        )

                      // Beacons list
                      : ListView.separated(
                          key: const PageStorageKey('FavoritesListView'),
                          itemCount: state.beacons.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, i) {
                            final beacon = state.beacons[i];
                            return Padding(
                              padding: kPaddingV,
                              child: BeaconTile(
                                beacon: beacon,
                                key: ValueKey(beacon),
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
