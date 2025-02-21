import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/profile_app_bar_title.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import '../bloc/profile_cubit.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = GetIt.I<ProfileCubit>();
    return BlocSelector<ProfileCubit, ProfileState, Profile>(
      selector: (state) => state.profile,
      bloc: profileCubit,
      builder: (_, profile) {
        return SliverAppBar(
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
            ShareCodeIconButton.id(profile.id),

            const Padding(padding: EdgeInsets.only(right: kSpacingSmall)),
          ],
          title: ProfileAppBarTitle(profile: profile),
          floating: true,
          snap: true,
        );
      },
    );
  }
}
