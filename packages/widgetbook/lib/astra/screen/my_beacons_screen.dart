import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';

import 'package:tentura_widgetbook/bloc/beacon_cubit.dart';

@UseCase(
  name: 'Default',
  type: MyBeaconsScreen,
  path: '[astra]/screen',
)
Widget myBeaconsListUseCase(BuildContext context) => BlocProvider<BeaconCubit>(
  create: (_) => BeaconCubitMock(),
  child: const BlocListener<BeaconCubit, BeaconState>(
    listener: commonScreenBlocListener,
    child: MyBeaconsScreen(),
  ),
);

class MyBeaconsScreen extends StatelessWidget {
  const MyBeaconsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<BeaconCubit, BeaconState>(
    builder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('My Beacons'),
        leading: const DeepBackButton(),
      ),
      body: state.beacons.isEmpty
          ? Center(
              child: Text(
                'There are no beacons yet',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.separated(
              key: ValueKey(state.beacons),
              itemCount: state.beacons.length,
              itemBuilder: (_, i) {
                final beacon = state.beacons[i];
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
    ),
  );
}
