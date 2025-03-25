import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura_root/i10n/I10n.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
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
    final beaconCubit = context.read<BeaconCubit>();
    final screenCubit = context.read<ScreenCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Graph View
        IconButton(
          icon: const Icon(Icons.hub_outlined),
          onPressed:
              beacon.myVote < 0 ? null : () => screenCubit.showGraph(beacon.id),
        ),

        // Share
        ShareCodeIconButton.id(beacon.id),

        // Menu
        PopupMenuButton<void>(
          itemBuilder:
              (context) => [
                // Enable / Disable
                PopupMenuItem<void>(
                  child: Text(
                    beaconCubit.state.beacons
                            .singleWhere((e) => e.id == beacon.id)
                            .isEnabled
                        ? I10n.of(context)!.disableBeacon
                        : I10n.of(context)!.enableBeacon,
                  ),
                  onTap: () async => beaconCubit.toggleEnabled(beacon.id),
                ),
                const PopupMenuDivider(),

                // Delete
                PopupMenuItem<void>(
                  child: Text(I10n.of(context)!.deleteBeacon),
                  onTap: () async {
                    if (await BeaconDeleteDialog.show(context) ?? false) {
                      await beaconCubit.delete(beacon.id);
                      if (goBackOnDelete && context.mounted) {
                        screenCubit.back();
                      }
                    }
                  },
                ),
              ],
        ),
      ],
    );
  }
}
