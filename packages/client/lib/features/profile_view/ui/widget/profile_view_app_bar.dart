import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/profile_app_bar_title.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import '../bloc/profile_view_cubit.dart';

class ProfileViewAppBar extends StatelessWidget {
  const ProfileViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewCubit = context.read<ProfileViewCubit>();
    return BlocSelector<ProfileViewCubit, ProfileViewState, Profile>(
      selector: (state) => state.profile,
      bloc: profileViewCubit,
      builder:
          (_, profile) => SliverAppBar(
            floating: true,
            snap: true,
            title: ProfileAppBarTitle(profile: profile),
            actions: [
              // Share
              ShareCodeIconButton.id(profile.id),

              // More
              PopupMenuButton(
                itemBuilder: (_) {
                  return <PopupMenuEntry<void>>[
                    if (profile.isFriend)
                      PopupMenuItem(
                        onTap: profileViewCubit.removeFriend,
                        child: const Text('Remove from my field'),
                      )
                    else
                      PopupMenuItem(
                        onTap: profileViewCubit.addFriend,
                        child: const Text('Add to my field'),
                      ),
                  ];
                },
              ),

              const Padding(padding: EdgeInsets.only(right: kSpacingSmall)),
            ],
          ),
    );
  }
}
