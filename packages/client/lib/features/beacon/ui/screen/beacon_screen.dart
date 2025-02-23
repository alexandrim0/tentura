import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';

import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_cubit.dart';
import '../widget/beacon_tile.dart';

@RoutePage()
class BeaconScreen extends StatelessWidget implements AutoRouteWrapper {
  const BeaconScreen({@queryParam this.id = '', super.key});

  final String id;

  @override
  Widget wrappedRoute(_) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ScreenCubit()),
      BlocProvider(
        create:
            (_) => BeaconCubit(
              profileId: id,
              isMine: GetIt.I<AuthCubit>().checkIfIsMe(id),
            ),
      ),
    ],
    child: MultiBlocListener(
      listeners: const [
        BlocListener<BeaconCubit, BeaconState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<ScreenCubit, ScreenState>(
          listener: commonScreenBlocListener,
        ),
      ],
      child: this,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: LinearPiActive.size,
          child: BlocSelector<BeaconCubit, BeaconState, bool>(
            selector: (state) => state.isLoading,
            builder: LinearPiActive.builder,
          ),
        ),
        title: const Text('Beacons'),
      ),
      body: BlocBuilder<BeaconCubit, BeaconState>(
        buildWhen: (_, c) => c.isSuccess,
        builder: (_, state) {
          return RefreshIndicator.adaptive(
            onRefresh: context.read<BeaconCubit>().fetch,
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
                            key: ValueKey(beacon),
                            isMine: state.isMine,
                            beacon: beacon,
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
