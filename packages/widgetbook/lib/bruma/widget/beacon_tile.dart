import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/author_info.dart';

import 'package:tentura/features/beacon/ui/widget/beacon_info.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_mine_control.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile_control.dart';

import 'community_info.dart';

class BeaconTile extends StatelessWidget {
  const BeaconTile({
    required this.beacon,
    required this.isMine,
    super.key,
  });

  final bool isMine;

  final Beacon beacon;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: kPaddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Community
          const CommunityInfo(),

          // User row (Avatar and Name)
          if (!isMine)
            Row(
              children: [
                // Info
                Expanded(
                  child: AuthorInfo(author: beacon.author),
                ),

                // More
                PopupMenuButton(
                  itemBuilder: (_) => [
                    // Complaint
                    PopupMenuItem<void>(
                      onTap: () => context.read<ScreenCubit>().showComplaint(
                        beacon.id,
                      ),
                      child: Text(L10n.of(context)!.buttonComplaint),
                    ),
                  ],
                ),
              ],
            ),

          // Beacon Info
          BeaconInfo(
            beacon: beacon,
            isTitleLarge: true,
            isShowBeaconEnabled: true,
          ),

          // Beacon Control
          Padding(
            padding: kPaddingSmallV,
            child: isMine
                ? BeaconMineControl(
                    key: ValueKey(beacon.id),
                    beacon: beacon,
                  )
                : BeaconTileControl(beacon: beacon),
          ),
        ],
      ),
    ),
  );
}
