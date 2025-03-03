import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/features/beacon/ui/widget/beacon_info.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_mine_control.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile_control.dart';
import 'package:tentura/features/comment/ui/bloc/comment_cubit.dart';
import 'package:tentura/features/comment/ui/widget/comment_tile.dart';
import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';

import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/bottom_text_input.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:tentura/ui/widget/author_info.dart';

import '../bloc/beacon_view_cubit.dart';

@RoutePage()
class BeaconViewScreen extends StatelessWidget implements AutoRouteWrapper {
  const BeaconViewScreen({@queryParam this.id = '', super.key});

  final String id;

  @override
  Widget wrappedRoute(_) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: GetIt.I<ScreenCubit>()),
      BlocProvider(
        create:
            (_) => BeaconViewCubit(
              myProfile: GetIt.I<ProfileCubit>().state.profile,
              id: id,
            ),
      ),
      BlocProvider(create: (_) => CommentCubit()),
    ],
    child: MultiBlocListener(
      listeners: const [
        BlocListener<ScreenCubit, ScreenState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<CommentCubit, CommentState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<BeaconViewCubit, BeaconViewState>(
          listener: commonScreenBlocListener,
        ),
      ],
      child: this,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final beaconViewCubit = context.read<BeaconViewCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon'),
        leading: const DeepBackButton(),
        actions: [
          // More
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuEntry<void>>[
                // Complaint
                PopupMenuItem(
                  onTap: () => context.read<ScreenCubit>().showComplaint(id),
                  child: const Text('Complaint'),
                ),
              ];
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: BlocSelector<BeaconViewCubit, BeaconViewState, bool>(
            selector: (state) => state.isLoading,
            builder: LinearPiActive.builder,
            bloc: beaconViewCubit,
          ),
        ),
      ),
      body: BlocBuilder<BeaconViewCubit, BeaconViewState>(
        bloc: beaconViewCubit,
        buildWhen: (_, c) => c.isSuccess,
        builder: (_, state) {
          final beacon = state.beacon;
          return ListView(
            padding: kPaddingH + const EdgeInsets.only(bottom: 80),
            children: [
              // User row (Avatar and Name)
              if (state.isBeaconNotMine)
                AuthorInfo(author: beacon.author, key: ValueKey(beacon.author)),

              // Beacon Info
              BeaconInfo(
                key: ValueKey(beacon),
                beacon: beacon,
                isTitleLarge: true,
                isShowMoreEnabled: false,
                isShowBeaconEnabled: false,
              ),

              // Buttons Row
              Padding(
                padding: kPaddingSmallV,
                child:
                    state.isBeaconMine
                        ? BeaconMineControl(
                          key: ValueKey(beacon.id),
                          goBackOnDelete: true,
                          beacon: beacon,
                        )
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

              // Comments list
              for (final comment in state.comments.reversed)
                CommentTile(
                  comment: comment,
                  key: ValueKey(comment),
                  isMine: state.checkIfCommentIsMine(comment),
                ),

              // Show All Button
              if (state.comments.isNotEmpty && state.hasNotReachedMax)
                Padding(
                  padding: kPaddingSmallV,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: beaconViewCubit.showAll,
                      child: const Text('Show all comments'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomSheet: BottomTextInput(
        hintText: 'Write a comment',
        onSend: beaconViewCubit.addComment,
      ),
    );
  }
}
