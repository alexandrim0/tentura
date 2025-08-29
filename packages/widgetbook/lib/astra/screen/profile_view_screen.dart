import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/features/opinion/ui/widget/opinion_tile.dart';
import 'package:tentura/features/profile_view/ui/bloc/profile_view_cubit.dart';

import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/bottom_text_input.dart';
import 'package:tentura/ui/widget/profile_app_bar_title.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';
import 'package:tentura_widgetbook/bloc/profile_view_cubit.dart';

import '../widget/theme_astra.dart';

@UseCase(
  name: 'View Profile',
  type: ProfileViewScreen,
  path: '[astra]/screen',
)
Widget defaultProfileMyUseCase(BuildContext context) =>
    BlocProvider<ProfileViewCubit>(
      create: (_) => ProfileViewCubitMock(),
      child: const BlocListener<ProfileViewCubit, ProfileViewState>(
        listener: commonScreenBlocListener,
        child: ProfileViewScreen(),
      ),
    );

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenCubit = context.read<ScreenCubit>();
    final profileViewCubit = context.read<ProfileViewCubit>();
    return BlocBuilder<ProfileViewCubit, ProfileViewState>(
      bloc: profileViewCubit,
      buildWhen: (_, c) => c.isSuccess,
      builder: (_, state) {
        final profile = state.profile;
        return ThemeAstra(
          child: Scaffold(
            bottomSheet: const BottomTextInput(
              hintText: 'Write an opinion',
            ),
            body: CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  snap: true,
                  floating: true,
                  title: ProfileAppBarTitle(profile: profile),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Avatar
                        Center(
                          child: AvatarRated.big(profile: profile),
                        ),

                        // Description
                        Padding(
                          padding: kPaddingT,
                          child: ShowMoreText(
                            profile.description,
                            style: textTheme.bodyMedium,
                          ),
                        ),

                        // Show Graph Button
                        Padding(
                          padding: kPaddingT,
                          child: ElevatedButton.icon(
                            onPressed: () => screenCubit.showGraph(profile.id),
                            icon: const Icon(TenturaIcons.graph),
                            label: const Text('Show Connections'),
                          ),
                        ),

                        // Show Beacons
                        Padding(
                          padding: kPaddingSmallT,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                screenCubit.showBeacons(profile.id),
                            icon: const Icon(Icons.open_in_full),
                            label: const Text('Show Beacons'),
                          ),
                        ),

                        // Add\Remove Friend
                        Padding(
                          padding: kPaddingSmallT,
                          child: FilledButton.icon(
                            onPressed: () => profile.isFriend
                                ? profileViewCubit.removeFriend()
                                : profileViewCubit.addFriend(),
                            icon: const Icon(Icons.people),
                            label: profile.isFriend
                                ? const Text('Add to My Field')
                                : const Text('Remove From My Field'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: profile.isFriend
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error,
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
                      ],
                    ),
                  ),
                ),

                // Comments List
                SliverList.list(
                  children: [
                    OpinionTile(opinion: commentsOnAlice[0]),
                    OpinionTile(opinion: commentsOnAlice[1]),
                    OpinionTile(opinion: commentsOnAlice[2]),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
