import 'package:flutter/material.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/ui/widget/bottom_text_input.dart';
import 'package:tentura_widgetbook/bloc/_data.dart';

import 'package:tentura_widgetbook/bruma/widget/community_info.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:tentura_widgetbook/bloc/beacon_cubit.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/widget/author_info.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_info.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_mine_control.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile_control.dart';

@UseCase(
  name: 'BeaconViewScreen',
  type: BeaconViewScreen,
  path: '[bruma]/screen',
)
Widget beaconViewScreenUseCase(BuildContext context) =>
    BlocProvider<BeaconCubit>(
      create: (_) => BeaconCubitMock(),
      child: BlocListener<BeaconCubit, BeaconState>(
        listener: commonScreenBlocListener,
        child: BeaconViewScreen(
          beacon: beaconA,
        ),
      ),
    );

class BeaconViewScreen extends StatelessWidget {
  const BeaconViewScreen({
    required this.beacon,
    this.isMine = false,
    this.comments = const [],
    super.key,
  });

  final Beacon beacon;
  final bool isMine;
  final List<String>
  comments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon (Widgetbook)'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: kPaddingH + const EdgeInsets.only(bottom: 80),
        children: [
          // Community Info
          const CommunityInfo(),

          // User row (Avatar and Name)
          if (!isMine)
            AuthorInfo(author: beacon.author, key: ValueKey(beacon.author)),

          // Beacon Info
          BeaconInfo(
            key: ValueKey(beacon),
            beacon: beacon,
            isTitleLarge: true,
            isShowMoreEnabled: false,
            isShowBeaconEnabled: false,
          ),

          // Beacon Control
          Padding(
            padding: kPaddingSmallV,
            child: isMine
                ? BeaconMineControl(key: ValueKey(beacon.id), beacon: beaconA,)
                : BeaconTileControl(
                    beacon: beacon,
                    key: ValueKey(beacon.id),
                  ),
          ),

          // Comments Section
          const Text(
            'Comments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          // Show All Button (мок)
          if (comments.isNotEmpty)
            Padding(
              padding: kPaddingSmallV,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Show all'),
                ),
              ),
            ),
        ],
      ),
      bottomSheet: const BottomTextInput(
        hintText: 'Write a comment',
      ),
    );
  }
}
