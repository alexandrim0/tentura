import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
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
    final profileViewCubit = context.read<ProfileViewCubit>();
    return BlocSelector<ProfileViewCubit, ProfileViewState, Profile>(
      bloc: profileViewCubit,
      selector: (state) => state.profile,
      builder: (context, profile) {
        return SliverToBoxAdapter(
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

                Padding(
                  padding: kPaddingSmallT,
                  child: ElevatedButton.icon(
                    onPressed: profileViewCubit.showGraph,
                    icon: const Icon(TenturaIcons.graph),
                    label: const Text('Show Connections'),
                  ),
                ),

                // Show Beacons
                Padding(
                  padding: kPaddingSmallT,
                  child: ElevatedButton.icon(
                    onPressed: profileViewCubit.showBeacons,
                    icon: const Icon(Icons.open_in_full),
                    label: const Text('Show Beacons'),
                  ),
                ),

                if (profile.isNotFriend)
                  Padding(
                    padding: kPaddingSmallT,
                    child: FilledButton.icon(
                      onPressed: profileViewCubit.addFriend,
                      icon: const Icon(Icons.people),
                      label: const Text('Add to My Field'),
                    ),
                  ),

                // Comments
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
