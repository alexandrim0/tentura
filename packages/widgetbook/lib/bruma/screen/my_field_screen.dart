import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

import '../widget/beacon_tile.dart';
import '../widget/tags_cloud.dart';

@UseCase(
  name: 'Default',
  type: MyFieldScreen,
  path: '[bruma]/screen',
)
Widget myFieldScreenUseCase(BuildContext context) => const MyFieldScreen();

class MyFieldScreen extends StatelessWidget {
  const MyFieldScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    minimum: kPaddingAll,
    child: Column(
      children: [
        // Context selector
        const ContextDropDown(
          key: Key('MyFieldContextSelector'),
        ),

        // Tags cloud
        const TagsCloud(),

        // Beacons list
        Expanded(
          child: ListView.builder(
            itemCount: _beacons.length,
            itemBuilder: (_, i) {
              final beacon = _beacons[i];
              return Padding(
                padding: kPaddingSmallV,
                child: BeaconTile(
                  key: ValueKey(beacon),
                  beacon: beacon,
                  isMine: false,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );

  static final _beacons = <Beacon>[
    beaconA,
    beaconB,
  ];
}
