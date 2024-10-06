import 'package:flutter/material.dart';

import '../../domain/entity/beacon.dart';
import 'beacon_author_info.dart';
import 'beacon_info.dart';
import 'beacon_tile_control.dart';

class BeaconTile extends StatelessWidget {
  const BeaconTile({
    required this.beacon,
    super.key,
  });

  final Beacon beacon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User row (Avatar and Name)
        BeaconAuthorInfo(author: beacon.author),

        // Beacon Info
        BeaconInfo(beacon: beacon),

        // Beacon Control
        BeaconTileControl(beacon: beacon),
      ],
    );
  }
}
