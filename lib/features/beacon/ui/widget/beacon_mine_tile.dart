import 'package:flutter/material.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../../domain/entity/beacon.dart';
import 'beacon_info.dart';
import 'beacon_mine_control.dart';

class BeaconMineTile extends StatelessWidget {
  const BeaconMineTile({
    required this.beacon,
    super.key,
  });

  final Beacon beacon;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BeaconInfo(beacon: beacon),
          Padding(
            padding: kPaddingSmallV,
            child: BeaconMineControl(beacon: beacon),
          ),
        ],
      );
}
