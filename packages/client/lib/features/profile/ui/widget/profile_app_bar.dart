import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/profile_app_bar_title.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import '../bloc/profile_cubit.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProfileCubit, ProfileState, Profile>(
      selector: (state) => state.profile,
      bloc: GetIt.I<ProfileCubit>(),
      builder: (context, profile) {
        final router = AutoRouter.of(context);
        return SliverAppBar(
          automaticallyImplyLeading: false,
          leading: router.currentPath == kPathProfile
              ? null
              : const DeepBackButton(),
          title: ProfileAppBarTitle(profile: profile),
          actions: [
            // Edit
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: context.read<ScreenCubit>().showProfileEditor,
            ),

            // Show Rating
            IconButton(
              icon: const Icon(Icons.leaderboard),
              onPressed: context.read<ScreenCubit>().showRating,
            ),

            // Share
            ShareCodeIconButton.id(profile.id),

            const Padding(padding: EdgeInsets.only(right: kSpacingSmall)),
          ],
          floating: true,
          snap: true,
        );
      },
    );
  }
}
