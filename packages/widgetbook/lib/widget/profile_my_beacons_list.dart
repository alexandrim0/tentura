import 'package:flutter/material.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_mine_tile.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura_widgetbook/bloc/_data.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Default',
  type: UsersBeaconsList,
  path: '[widget]/my_beacons_list',
)
Widget myBeaconsListUseCase(BuildContext context) =>
    UsersBeaconsList(beacons: [beaconA, beaconB]);

class UsersBeaconsList extends StatelessWidget {
  const UsersBeaconsList({
    required this.beacons,
    super.key,
  });

  final List<Beacon> beacons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Beacons'),
        leading: const DeepBackButton(),
      ),
      body: CustomScrollView(
        slivers: [
          if (beacons.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: kPaddingAll,
                child: Text(
                  'There are no beacons yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            SliverList.separated(
              key: ValueKey(beacons),
              itemCount: beacons.length,
              itemBuilder: (context, i) {
                final beacon = beacons[i];
                return Padding(
                  padding: kPaddingAll,
                  child: BeaconMineTile(beacon: beacon, key: ValueKey(beacon)),
                );
              },
              separatorBuilder:
                  (_, __) => const Divider(endIndent: 20, indent: 20),
            ),

          // Show more
          //   if (beacons.isNotEmpty && state.hasNotReachedMax)
          //     SliverToBoxAdapter(
          //       child: Padding(
          //         padding: kPaddingAll,
          //         child: TextButton(
          //           onPressed: profileViewCubit.fetchMore,
          //           child: const Text('Show more'),
          //         ),
          //       ),
          //     ),
        ],
      ),
    );
  }
}
