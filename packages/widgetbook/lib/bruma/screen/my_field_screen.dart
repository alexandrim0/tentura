import 'package:flutter/material.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura_widgetbook/bloc/_data.dart';

import 'package:tentura_widgetbook/bruma/screen/beacon_tile.dart';
import 'package:tentura_widgetbook/bruma/widget/tags_cloud.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

@UseCase(
  name: 'MyFieldScreen',
  type: MyFieldScreen,
  path: '[bruma]/screen',
)
Widget myFieldScreenUseCase(BuildContext context) => MyFieldScreen(
  beacons: [beaconA, beaconB],
);

class MyFieldScreen extends StatelessWidget {
  const MyFieldScreen({
    required this.beacons,
    super.key,
  });

  final List<Beacon> beacons;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: kPaddingAll,
      child: Column(
        children: [
          // Context selector
          const ContextDropDown(key: Key('MyFieldContextSelector')),

          // Tags cloud
          const TagsCloud(),

          // Beacons list
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                await Future<void>.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.separated(
                itemCount: beacons.length,
                separatorBuilder: separatorBuilder,
                itemBuilder: (_, i) {
                  final beacon = beacons[i];
                  return Padding(
                    padding: kPaddingV,
                    child: BeaconTile(
                      key: ValueKey(beacon),
                      beacon: beacon,
                      isMine: false,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
