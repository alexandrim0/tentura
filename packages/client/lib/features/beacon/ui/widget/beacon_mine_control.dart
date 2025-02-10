import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import '../bloc/beacon_cubit.dart';
import '../dialog/beacon_delete_dialog.dart';

class BeaconMineControl extends StatelessWidget {
  const BeaconMineControl({
    required this.beacon,
    required this.goBackOnDelete,
    super.key,
  });

  final Beacon beacon;

  final bool goBackOnDelete;

  @override
  Widget build(BuildContext context) {
    final beaconCubit = GetIt.I<BeaconCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Graph View
        IconButton(
          icon: const Icon(Icons.hub_outlined),
          onPressed:
              beacon.myVote < 0 ? null : () => beaconCubit.showGraph(beacon.id),
        ),

        // Share
        ShareCodeIconButton.id(beacon.id),

        // Menu
        PopupMenuButton<void>(
          itemBuilder: (context) => [
            // Enable / Disable
            PopupMenuItem<void>(
              child: beaconCubit.state.beacons
                      .singleWhere((e) => e.id == beacon.id)
                      .isEnabled
                  ? const Text('Disable beacon')
                  : const Text('Enable beacon'),
              onTap: () async => beaconCubit.toggleEnabled(beacon.id),
            ),
            const PopupMenuDivider(),

            // Delete
            PopupMenuItem<void>(
              child: const Text('Delete beacon'),
              onTap: () async {
                if (await BeaconDeleteDialog.show(context) ?? false) {
                  await beaconCubit.delete(beacon.id);
                  if (goBackOnDelete && context.mounted) context.back();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
