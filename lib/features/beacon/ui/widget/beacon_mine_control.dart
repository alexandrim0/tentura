import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_cubit.dart';
import '../dialog/beacon_delete_dialog.dart';

class BeaconMineControl extends StatelessWidget {
  const BeaconMineControl({
    required this.beacon,
    super.key,
  });

  final Beacon beacon;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Graph View
          IconButton(
            icon: const Icon(Icons.hub_outlined),
            onPressed: beacon.myVote < 0
                ? null
                : () => context.pushRoute(GraphRoute(focus: beacon.id)),
          ),

          // Share
          ShareCodeIconButton.id(beacon.id),

          // Menu
          PopupMenuButton<void>(
            itemBuilder: (context) {
              final beaconCubit = GetIt.I<BeaconCubit>();
              return [
                // Enable / Disable
                PopupMenuItem<void>(
                  child: beaconCubit.state.beacons
                          .singleWhere((e) => e.id == beacon.id)
                          .isEnabled
                      ? const Text('Disable beacon')
                      : const Text('Enable beacon'),
                  onTap: () async {
                    try {
                      await beaconCubit.toggleEnabled(beacon.id);
                    } catch (e) {
                      if (context.mounted) {
                        showSnackBar(
                          context,
                          isError: true,
                          text: e.toString(),
                        );
                      }
                    }
                  },
                ),
                const PopupMenuDivider(),

                // Delete
                PopupMenuItem<void>(
                  child: const Text('Delete beacon'),
                  onTap: () => BeaconDeleteDialog.show(
                    context,
                    id: beacon.id,
                  ),
                ),
              ];
            },
          ),
        ],
      );
}
