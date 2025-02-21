import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';

import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacons_view_cubit.dart';

@RoutePage()
class BeaconsViewScreen extends StatelessWidget implements AutoRouteWrapper {
  const BeaconsViewScreen({@queryParam this.id = '', super.key});

  final String id;

  @override
  Widget wrappedRoute(_) => BlocProvider(
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
  Widget build(BuildContext context) {
    final beaconsViewCubit = context.read<BeaconsViewCubit>();
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: LinearPiActive.size,
          child: BlocSelector<BeaconsViewCubit, BeaconsViewState, bool>(
            selector: (state) => state.isLoading,
            builder: LinearPiActive.builder,
          ),
        ),
        title: const Text('Beacons'),
      ),
      body: BlocBuilder<BeaconsViewCubit, BeaconsViewState>(
        bloc: beaconsViewCubit,
        buildWhen: (_, c) => c.isSuccess,
        builder: (_, state) {
          return RefreshIndicator.adaptive(
            onRefresh: beaconsViewCubit.fetch,
            child:
                state.beacons.isEmpty
                    ? Center(
                      child: Text(
                        'There are no beacons yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                    : ListView.separated(
                      key: ValueKey(state.beacons),
                      itemCount: state.beacons.length,
                      itemBuilder: (_, i) {
                        final beacon = state.beacons[i];
                        return Padding(
                          padding: kPaddingAll,
                          child: BeaconTile(
                            beacon: beacon,
                            key: ValueKey(beacon),
                            onAvatarInfoTap:
                                () => beaconsViewCubit.showProfile(
                                  beacon.author.id,
                                ),
                          ),
                        );
                      },
                      separatorBuilder: separatorBuilder,
                    ),
          );
        },
      ),
    );
  }
}
