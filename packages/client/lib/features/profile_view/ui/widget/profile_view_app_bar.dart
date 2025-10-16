import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/profile_app_bar_title.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import '../bloc/profile_view_cubit.dart';

class ProfileViewAppBar extends StatelessWidget {
  const ProfileViewAppBar({
    required this.isFromDeepLink,
    super.key,
  });

  final bool isFromDeepLink;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final screenCubit = context.read<ScreenCubit>();
    final profileViewCubit = context.read<ProfileViewCubit>();
    return BlocSelector<ProfileViewCubit, ProfileViewState, Profile>(
      bloc: profileViewCubit,
      selector: (state) => state.profile,
      builder: (context, profile) => SliverAppBar(
        floating: true,
        snap: true,
        leading: isFromDeepLink
            ? BackButton(
                onPressed: () => context.router.navigatePath(kPathHome),
              )
            : const AutoLeadingButton(),
        title: ProfileAppBarTitle(profile: profile),
        actions: [
          // Share
          ShareCodeIconButton.id(profile.id),

          // More
          PopupMenuButton(
            itemBuilder: (_) => <PopupMenuEntry<void>>[
              if (profile.isFriend)
                PopupMenuItem(
                  onTap: profileViewCubit.removeFriend,
                  child: Text(l10n.removeFromMyField),
                ),

              // Complaint
              PopupMenuItem(
                onTap: () => screenCubit.showComplaint(profile.id),
                child: Text(l10n.buttonComplaint),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.only(right: kSpacingSmall),
          ),
        ],
      ),
    );
  }
}
