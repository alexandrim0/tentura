import 'package:flutter/material.dart';

import 'package:tentura/features/opinion/ui/widget/opinion_tile.dart';
import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';
import 'package:tentura_widgetbook/astra/widget/theme_astra.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';
import 'package:tentura_widgetbook/utils/navigation_bar.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'My Profile',
  type: ProfileScreen,
  path: '[astra]/screen/profile.My',
)
Widget defaultProfileUseCase(BuildContext context) => const ProfileScreen();

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = GetIt.I<ProfileCubit>();
    return ThemeAstra(
      child: Scaffold(
        // TODO: remove bottomNavigationBar
        bottomNavigationBar: buildNavigationBar(index: 4),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          buildWhen: (p, c) => c.isSuccess,
          builder: (context, state) {
            final profile = state.profile;
            final textTheme = Theme.of(context).textTheme;
            return RefreshIndicator.adaptive(
              onRefresh: profileCubit.fetch,
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverAppBar(
                    key: Key('ProfileMineScreen:${profile.avatarUrl}'),
                    floating: true,
                    snap: true,
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
                      // Edit
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: profileCubit.showProfileEditor,
                      ),

                      // Show Rating
                      IconButton(
                        icon: const Icon(Icons.leaderboard),
                        onPressed: profileCubit.showRating,
                      ),

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
                          Center(
                            child: AvatarRated(
                              withRating: false,
                              profile: profile,
                              size: 160,
                            ),
                          ),

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
                            child: Column(
                              children: [
                                // Show Connections
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () =>
                                            profileCubit.showGraph(profile.id),
                                    icon: const Icon(TenturaIcons.graph),
                                    label: const Text('Show Connections'),
                                  ),
                                ),

                                const Padding(padding: kPaddingSmallT),

                                // Show Beacons
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.open_in_full),
                                    label: const Text('Show Beacons'),
                                  ),
                                ),

                                const Padding(padding: kPaddingSmallT),

                                Row(
                                  spacing: kSpacingSmall,
                                  children: [
                                    // Settings
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.settings),
                                        label: const Text('Settings'),
                                      ),
                                    ),

                                    // New Beacon
                                    Expanded(
                                      child: FilledButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.post_add),
                                        label: const Text('New Beacon'),
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
