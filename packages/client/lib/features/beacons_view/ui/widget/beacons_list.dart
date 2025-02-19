import 'package:flutter/material.dart';

class BeaconsList extends StatelessWidget {
  const BeaconsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // Beacons
  // if (beacons.isEmpty)
  //   SliverToBoxAdapter(
  //     child: Padding(
  //       padding: kPaddingAll,
  //       child: Text(
  //         'There are no beacons yet',
  //         style: textTheme.bodyMedium,
  //       ),
  //     ),
  //   )
  // else
  //   SliverList.separated(
  //     key: ValueKey(beacons),
  //     itemCount: beacons.length,
  //     itemBuilder: (context, i) {
  //       final beacon = beacons[i];
  //       return Padding(
  //         padding: kPaddingAll,
  //         child: BeaconTile(
  //           beacon: beacon,
  //           key: ValueKey(beacon),
  //         ),
  //       );
  //     },
  //     separatorBuilder: (_, __) =>
  //         const Divider(endIndent: 20, indent: 20),
  //   ),
}
