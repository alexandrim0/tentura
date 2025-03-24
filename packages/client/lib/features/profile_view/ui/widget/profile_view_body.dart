import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:localization/localization.dart';
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
                  label: Text(AppLocalizations.of(context)!.showConnections),
                ),
              ),

              // Show Beacons
              Padding(
                padding: kPaddingSmallT,
                child: ElevatedButton.icon(
                  onPressed:
                      () => context.read<ScreenCubit>().showBeacons(profile.id),
                  icon: const Icon(Icons.open_in_full),
                  label: Text(AppLocalizations.of(context)!.showBeacons),
                ),
              ),

              if (profile.isNotFriend)
                Padding(
                  padding: kPaddingSmallT,
                  child: FilledButton.icon(
                    onPressed: context.read<ProfileViewCubit>().addFriend,
                    icon: const Icon(Icons.people),
                    label: Text(AppLocalizations.of(context)!.addToMyField),
                  ),
                ),

              // Opinions
              Padding(
                padding: kPaddingV,
                child: Text(
                  AppLocalizations.of(context)!.communityFeedback,
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
