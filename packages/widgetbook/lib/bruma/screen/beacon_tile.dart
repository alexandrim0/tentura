import 'package:flutter/material.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura_widgetbook/bloc/_data.dart';

import 'package:tentura_widgetbook/bruma/widget/community_info.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:tentura_widgetbook/bloc/beacon_cubit.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/widget/author_info.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_info.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_mine_control.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile_control.dart';

@UseCase(
  name: 'BeaconTile',
  type: BeaconTile,
  path: '[bruma]/screen',
)
Widget beaconTileUseCase(BuildContext context) => BlocProvider<BeaconCubit>(
  create: (_) => BeaconCubitMock(),
  child: BlocListener<BeaconCubit, BeaconState>(
    listener: commonScreenBlocListener,
    child: BeaconTile(
      beacon: beaconA,
      isMine: false,
    ),
  ),
);

class BeaconTile extends StatelessWidget {
  const BeaconTile({
    required this.beacon,
    required this.isMine,
    super.key,
  });

  final bool isMine;

  final Beacon beacon;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return DecoratedBox(
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
                  Expanded(
                    child: AuthorInfo(author: beacon.author),
                  ),

                  // More
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return <PopupMenuEntry<void>>[
                        // Complaint
                        PopupMenuItem(
                          onTap: () =>
                              context.read<ScreenCubit>().showComplaint(
                                beacon.id,
                              ),
                          child: Text(l10n.buttonComplaint),
                        ),
                      ];
                    },
                  ),
                ],
              ),

            // Beacon Info
            BeaconInfo(
              beacon: beacon,
              isShowBeaconEnabled: true,
              isTitleLarge: true,
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
}
