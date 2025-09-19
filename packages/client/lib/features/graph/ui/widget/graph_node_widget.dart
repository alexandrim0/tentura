import 'package:flutter/material.dart';

import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/beacon_image.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../../domain/entity/node_details.dart';

class GraphNodeWidget extends StatelessWidget {
  const GraphNodeWidget({
    required this.nodeDetails,
    this.withEye = false,
    this.onDoubleTap,
    this.onTap,
    super.key,
  });

  final bool withEye;
  final NodeDetails nodeDetails;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final widget = SizedBox.square(
      dimension: nodeDetails.size,
      child: switch (nodeDetails) {
        //
        final UserNode userNode =>
          withEye
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AvatarRated(
                      profile: userNode.user,
                      size: nodeDetails.size,
                    ),
                    Positioned(
                      bottom: -5,
                      right: -12,
                      child: userNode.canSeeMe
                          ? const Icon(TenturaIcons.eyeOpen)
                          : const Icon(TenturaIcons.eyeClosed),
                    ),
                  ],
                )
              : AvatarRated(
                  profile: userNode.user,
                  size: nodeDetails.size,
                ),
        //
        final BeaconNode beaconNode => BeaconImage(
          beacon: beaconNode.beacon,
        ),
      },
    );
    return onTap == null && onDoubleTap == null
        ? widget
        : GestureDetector(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            child: widget,
          );
  }
}
