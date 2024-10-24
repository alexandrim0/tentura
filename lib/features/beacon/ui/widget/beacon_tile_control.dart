import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import 'package:tentura/features/favorites/ui/widget/beacon_pin_icon_button.dart';
import 'package:tentura/features/like/ui/widget/like_control.dart';

import '../../domain/entity/beacon.dart';

class BeaconTileControl extends StatelessWidget {
  const BeaconTileControl({
    required this.beacon,
    super.key,
  });

  final Beacon beacon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: kPaddingSmallT,
        child: Row(
          children: [
            // Graph View
            IconButton(
              icon: const Icon(TenturaIcons.graph),
              onPressed: beacon.myVote < 0
                  ? null
                  : () => context.pushRoute(GraphRoute(focus: beacon.id)),
            ),

            // Share
            ShareCodeIconButton.id(beacon.id),

            // Favorite
            BeaconPinIconButton(
              beacon: beacon,
              key: ValueKey(beacon.author),
            ),

            const Spacer(),
            // Like\Dislike
            LikeControl(
              entity: beacon,
              key: ValueKey(beacon),
            ),
          ],
        ),
      );
}
