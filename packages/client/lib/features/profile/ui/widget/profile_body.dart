import 'package:flutter/material.dart';

import 'package:tentura_root/l10n/l10n.dart';

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
    final l10n = L10n.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final screenCubit = context.read<ScreenCubit>();
    return BlocSelector<ProfileCubit, ProfileState, Profile>(
      bloc: GetIt.I<ProfileCubit>(),
      selector: (state) => state.profile,
      builder: (_, profile) {
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar
              Center(
                child: AvatarRated.big(profile: profile, withRating: false),
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
                  label: Text(l10n.showConnections),
                ),
              ),

              // Show Beacons
              Padding(
                padding: kPaddingSmallT,
                child: ElevatedButton.icon(
                  onPressed: () => screenCubit.showBeacons(profile.id),
                  icon: const Icon(Icons.open_in_full),
                  label: Text(l10n.showBeacons),
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
                        label: Text(l10n.labelSettings),
                        onPressed: screenCubit.showSettings,
                      ),
                    ),

                    // New Beacon
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.post_add),
                        label: Text(l10n.newBeacon),
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
                  l10n.communityFeedback,
                  style: textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
