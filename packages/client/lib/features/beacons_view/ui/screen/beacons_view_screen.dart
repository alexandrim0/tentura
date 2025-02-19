import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacons_view_cubit.dart';

@RoutePage()
class BeaconsViewScreen extends StatelessWidget implements AutoRouteWrapper {
  const BeaconsViewScreen({@queryParam this.id = '', super.key});

  final String id;

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create:
        (_) => BeaconsViewCubit(
          isMine: GetIt.I<AuthCubit>().checkIfIsMe(id),
          profileId: id,
        ),
    child: BlocListener<BeaconsViewCubit, BeaconsViewState>(
      listener: commonScreenBlocListener,
      child: this,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<BeaconsViewCubit, BeaconsViewState>(
        builder:
            (context, state) =>
                state.beacons.isEmpty
                    ? SliverToBoxAdapter(
                      child: Padding(
                        padding: kPaddingAll,
                        child: Text(
                          'There are no beacons yet',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                    : SliverList.separated(
                      key: ValueKey(state.beacons),
                      itemCount: state.beacons.length,
                      itemBuilder: (_, i) {
                        final beacon = state.beacons[i];
                        return Padding(
                          padding: kPaddingAll,
                          child: BeaconTile(
                            beacon: beacon,
                            key: ValueKey(beacon),
                          ),
                        );
                      },
                      separatorBuilder:
                          (_, _) => const Divider(endIndent: 20, indent: 20),
                    ),
      );
}
