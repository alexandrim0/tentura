import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';

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
    final l10n = L10n.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return BlocSelector<ProfileViewCubit, ProfileViewState, Profile>(
      selector: (state) => state.profile,
      builder: (context, profile) {
        return SliverToBoxAdapter(
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
                  colorClickableText: Theme.of(context).colorScheme.primary,
                ),
              ),

              Padding(
                padding: kPaddingSmallT,
                child: OutlinedButton.icon(
                  onPressed:
                      () => context.read<ScreenCubit>().showGraph(profile.id),
                  icon: const Icon(TenturaIcons.graph),
                  label: Text(l10n.showConnections),
                ),
              ),

              // Show Beacons
              Padding(
                padding: kPaddingSmallT,
                child: OutlinedButton.icon(
                  onPressed:
                      () => context.read<ScreenCubit>().showBeacons(profile.id),
                  icon: const Icon(Icons.open_in_full),
                  label: Text(l10n.showBeacons),
                ),
              ),

              if (profile.isNotFriend)
                Padding(
                  padding: kPaddingSmallT,
                  child: FilledButton.icon(
                    onPressed: context.read<ProfileViewCubit>().addFriend,
                    icon: const Icon(Icons.people),
                    label: Text(l10n.addToMyField),
                  ),
                ),

              // Opinions
              Padding(
                padding: kPaddingV,
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
