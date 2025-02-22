import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

@UseCase(
  name: 'Default',
  type: UsersBeaconsList,
  path: '[astra]/widget/my_beacons_list',
)
Widget myBeaconsListUseCase(BuildContext context) =>
    UsersBeaconsList(beacons: [beaconA, beaconB]);

class UsersBeaconsList extends StatelessWidget {
  const UsersBeaconsList({required this.beacons, super.key});

  final List<Beacon> beacons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Beacons'),
        leading: const DeepBackButton(),
      ),
      body:
          beacons.isEmpty
              ? Center(
                child: Text(
                  'There are no beacons yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
              : ListView.separated(
                key: ValueKey(beacons),
                itemCount: beacons.length,
                itemBuilder: (context, i) {
                  final beacon = beacons[i];
                  return Padding(
                    padding: kPaddingAll,
                    child: BeaconTile(
                      beacon: beacon,
                      isMine: true,
                      key: ValueKey(beacon),
                    ),
                  );
                },
                separatorBuilder: separatorBuilder,
              ),
    );
  }
}
