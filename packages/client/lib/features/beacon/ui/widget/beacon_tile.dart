import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/beacon.dart';

import 'package:tentura/ui/widget/author_info.dart';

import 'beacon_info.dart';
import 'beacon_tile_control.dart';

class BeaconTile extends StatelessWidget {
  const BeaconTile({required this.beacon, this.onAvatarInfoTap, super.key});

  final Beacon beacon;

  final VoidCallback? onAvatarInfoTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // User row (Avatar and Name)
      AuthorInfo(author: beacon.author, onTap: onAvatarInfoTap),

      // Beacon Info
      BeaconInfo(beacon: beacon, isShowBeaconEnabled: true),

      // Beacon Control
      BeaconTileControl(beacon: beacon),
    ],
  );
}
