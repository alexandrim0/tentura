import 'package:flutter/material.dart';

import 'package:tentura_root/i10n/I10n.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/author_info.dart';

import 'beacon_info.dart';
import 'beacon_mine_control.dart';
import 'beacon_tile_control.dart';

class BeaconTile extends StatelessWidget {
  const BeaconTile({required this.beacon, required this.isMine, super.key});

  final bool isMine;

  final Beacon beacon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // User row (Avatar and Name)
      if (!isMine)
        Row(
          children: [
            Expanded(child: AuthorInfo(author: beacon.author)),

            // More
            PopupMenuButton(
              itemBuilder: (context) {
                return <PopupMenuEntry<void>>[
                  // Complaint
                  PopupMenuItem(
                    onTap:
                        () => context.read<ScreenCubit>().showComplaint(
                          beacon.id,
                        ),
                    child: Text(I10n.of(context)!.buttonComplaint),
                  ),
                ];
              },
            ),
          ],
        ),

      // Beacon Info
      BeaconInfo(beacon: beacon, isShowBeaconEnabled: true),

      // Beacon Control
      Padding(
        padding: kPaddingSmallV,
        child:
            isMine
                ? BeaconMineControl(key: ValueKey(beacon.id), beacon: beacon)
                : BeaconTileControl(beacon: beacon),
      ),
    ],
  );
}
