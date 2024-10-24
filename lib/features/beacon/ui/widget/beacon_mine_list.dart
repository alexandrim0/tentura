import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_cubit.dart';
import 'beacon_mine_tile.dart';

class BeaconMineList extends StatelessWidget {
  const BeaconMineList({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<BeaconCubit, BeaconState>(
        bloc: GetIt.I<BeaconCubit>(),
        listenWhen: (p, c) => c.hasError,
        listener: showSnackBarError,
        buildWhen: (p, c) => c.hasNoError,
        builder: (context, state) => state.beacons.isEmpty
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
                key: ValueKey(state),
                itemCount: state.beacons.length,
                itemBuilder: (context, i) {
                  final beacon = state.beacons[i];
                  return Padding(
                    padding: kPaddingH,
                    child: BeaconMineTile(
                      beacon: beacon,
                      key: ValueKey(beacon),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(
                  endIndent: 20,
                  indent: 20,
                ),
              ),
      );
}
