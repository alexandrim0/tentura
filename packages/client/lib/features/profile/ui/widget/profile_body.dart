import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/profile_cubit.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profileCubit = GetIt.I<ProfileCubit>();
    final screenCubit = context.read<ScreenCubit>();
    return BlocSelector<ProfileCubit, ProfileState, Profile>(
      bloc: profileCubit,
      selector: (state) => state.profile,
      builder: (_, profile) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: kPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar
                Center(
                  child: AvatarRated(
                    profile: profile,
                    size: 160,
                    withRating: false,
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

                // Show Connections
                Padding(
                  padding: kPaddingSmallT,
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
                    onPressed: () => screenCubit.showBeacons(profile.id),
                    icon: const Icon(Icons.open_in_full),
                    label: const Text('Show Beacons'),
                  ),
                ),

                Padding(
                  padding: kPaddingSmallT,
                  child: Row(
                    spacing: kSpacingSmall,
                    children: [
                      // Settings
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.settings),
                          label: const Text('Settings'),
                          onPressed: screenCubit.showSettings,
                        ),
                      ),

                      // New Beacon
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.post_add),
                          label: const Text('New Beacon'),
                          onPressed: screenCubit.showBeaconCreate,
                        ),
                      ),
                    ],
                  ),
                ),

                // Opinions
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
        );
      },
    );
  }
}
