import 'package:flutter/material.dart';

import 'package:tentura/features/opinion/ui/widget/opinion_tile.dart';
import 'package:tentura/features/profile_view/ui/bloc/profile_view_state.dart';

import 'package:tentura/ui/bloc/state_base.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/bottom_text_input.dart';
import 'package:tentura/ui/widget/profile_app_bar_title.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura_widgetbook/astra/widget/theme_astra.dart';
import 'package:tentura_widgetbook/bloc/_data.dart';
import 'package:tentura_widgetbook/bloc/profile_view_cubit.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'View Profile',
  type: ProfileViewScreen,
  path: '[astra]/screen/profile.View',
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final profileViewCubit = context.read<ProfileViewCubit>();
    return BlocBuilder<ProfileViewCubit, ProfileViewState>(
      bloc: profileViewCubit,
      buildWhen: (_, c) => c.isSuccess,
      builder: (context, state) {
        final profile = state.profile;
        return ThemeAstra(
          child: Scaffold(
            bottomSheet: const BottomTextInput(hintText: 'Write an opinion'),
            body: CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  floating: true,
                  snap: true,
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
                        Center(child: AvatarRated(profile: profile, size: 160)),

                        // Description
                        Padding(
                          padding: kPaddingT,
                          child: ShowMoreText(
                            profile.description,
                            style: textTheme.bodyMedium,
                          ),
                        ),

                        const Padding(padding: kPaddingT),

                        ElevatedButton.icon(
                          onPressed:
                              () => profileViewCubit.showGraph(profile.id),
                          icon: const Icon(TenturaIcons.graph),
                          label: const Text('Show Connections'),
                        ),
                        const Padding(padding: kPaddingSmallT),

                        // Show Beacons
                        ElevatedButton.icon(
                          onPressed:
                              () => profileViewCubit.showBeacons(profile.id),
                          icon: const Icon(Icons.open_in_full),
                          label: const Text('Show Beacons'),
                        ),

                        const Padding(padding: kPaddingSmallT),

                        FilledButton.icon(
                          onPressed:
                              () =>
                                  profile.isFriend
                                      ? profileViewCubit.removeFriend()
                                      : profileViewCubit.addFriend(),
                          icon: const Icon(Icons.people),
                          label:
                              profile.isFriend
                                  ? const Text('Add to My Field')
                                  : const Text('Remove From My Field'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                profile.isFriend
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.error,
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
          ),
        );
      },
    );
  }
}
