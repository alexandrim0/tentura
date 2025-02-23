import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/profile_view_cubit.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocSelector<ProfileViewCubit, ProfileViewState, Profile>(
      selector: (state) => state.profile,
      builder: (context, profile) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: kPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar
                Center(child: AvatarRated.big(profile: profile)),

                // Description
                Padding(
                  padding: kPaddingT,
                  child: ShowMoreText(
                    profile.description,
                    style: textTheme.bodyMedium,
                  ),
                ),

                Padding(
                  padding: kPaddingSmallT,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => context.read<ScreenCubit>().showGraph(profile.id),
                    icon: const Icon(TenturaIcons.graph),
                    label: const Text('Show Connections'),
                  ),
                ),

                // Show Beacons
                Padding(
                  padding: kPaddingSmallT,
                  child: ElevatedButton.icon(
                    onPressed:
                        () =>
                            context.read<ScreenCubit>().showBeacons(profile.id),
                    icon: const Icon(Icons.open_in_full),
                    label: const Text('Show Beacons'),
                  ),
                ),

                if (profile.isNotFriend)
                  Padding(
                    padding: kPaddingSmallT,
                    child: FilledButton.icon(
                      onPressed: context.read<ProfileViewCubit>().addFriend,
                      icon: const Icon(Icons.people),
                      label: const Text('Add to My Field'),
                    ),
                  ),

                // Opinions
                Padding(
                  padding: kPaddingV,
                  child: Text(
                    'Community Feedback',
                    style: textTheme.headlineMedium,
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
