import 'package:flutter/material.dart';

import 'package:tentura/features/beacon_view/ui/widget/new_comment_input.dart';
import 'package:tentura/features/opinion/ui/widget/opinion_tile.dart';
import 'package:tentura/features/profile_view/ui/bloc/profile_view_state.dart';
import 'package:tentura/ui/bloc/state_base.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';
import 'package:tentura_widgetbook/bloc/profile_view_cubit.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'View Profile',
  type: ProfileViewScreen,
  path: '[screen]/profile.View',
)
Widget defaultProfileMyUseCase(BuildContext context) =>
    const ProfileViewScreenWrapper();

class ProfileViewScreenWrapper extends StatelessWidget {
  const ProfileViewScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProfileViewCubit(),
    child: const BlocListener<ProfileViewCubit, ProfileViewState>(
      listener: commonScreenBlocListener,
      child: ProfileViewScreen(),
    ),
  );
}

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewCubit, ProfileViewState>(
      buildWhen: (p, c) => c.isSuccess || c.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final profile = state.profile;
        final textTheme = Theme.of(context).textTheme;
        final profileViewCubit = context.read<ProfileViewCubit>();
        return Scaffold(
          body: Theme(
            data: Theme.of(context).copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            child: CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  key: Key('ProfileMineScreen:${profile.avatarUrl}'),
                  title: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            profile.title.isEmpty ? 'No name' : profile.title,
                            style: textTheme.headlineMedium,
                            textAlign: TextAlign.left,
                          ),

                          // ID
                          Text(
                            profile.id,
                            style: textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: textTheme.bodySmall!.fontSize,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    // Share
                    Padding(
                      padding: const EdgeInsets.only(right: kSpacingSmall),
                      child: ShareCodeIconButton.id(profile.id),
                    ),
                  ],
                ),

                // Profile
                SliverToBoxAdapter(
                  key: ValueKey(profile),
                  child: Padding(
                    padding: kPaddingAll,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Center(child: AvatarRated(profile: profile, size: 160)),

                        // Description
                        Padding(
                          padding: kPaddingT,
                          child: ShowMoreText(
                            profile.description,
                            style: textTheme.bodyMedium,
                          ),
                        ),

                        Padding(
                          padding: kPaddingT,
                          child: Expanded(
                            child: Column(
                              children: [
                                // Show Connections
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () => profileViewCubit.showGraph(
                                          profile.id,
                                        ),
                                    icon: const Icon(TenturaIcons.graph),
                                    label: const Text('Show Connections'),
                                  ),
                                ),
                                const Padding(padding: kPaddingSmallT),

                                // Show Beacons
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () => profileViewCubit.showBeacons(
                                          profile.id,
                                        ),
                                    icon: const Icon(Icons.open_in_full),
                                    label: const Text('Show Beacons'),
                                  ),
                                ),

                                const Padding(padding: kPaddingSmallT),

                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed:
                                        () =>
                                            profile.isFriend
                                                ? profileViewCubit
                                                    .removeFriend()
                                                : profileViewCubit.addFriend(),
                                    icon: const Icon(Icons.people),
                                    label:
                                        profile.isFriend
                                            ? const Text('Add to My Field')
                                            : const Text(
                                              'Remove From My Field',
                                            ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor:
                                          profile.isFriend
                                              ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                              : Theme.of(
                                                context,
                                              ).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Comments
                        Padding(
                          padding: kPaddingT,
                          child: Text(
                            'Community Feedback',
                            style: textTheme.headlineMedium,
                          ),
                        ),

                        // Comments List
                        OpinionTile(opinion: commentsOnAlice[0]),
                        OpinionTile(opinion: commentsOnAlice[1]),
                        OpinionTile(opinion: commentsOnAlice[2]),

                        //New comment
                        //TODO: update for opinions
                        const NewCommentInput(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
