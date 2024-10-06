import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/auth/ui/dialog/show_seed_dialog.dart';
import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';
import 'package:tentura/features/settings/ui/widget/theme_switch_button.dart';

class ProfileMineMenuButton extends StatelessWidget {
  const ProfileMineMenuButton({super.key});

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry<void>>[
          // Rating
          PopupMenuItem<void>(
            onTap: () => context.pushRoute(const RatingRoute()),
            child: const Text('View rating'),
          ),
          const PopupMenuDivider(),

          // Seed
          PopupMenuItem<void>(
            child: const Text('Show seed'),
            onTap: () => ShowSeedDialog.show(
              context,
              userId: GetIt.I<AuthCubit>().state.currentAccountId,
            ),
          ),
          const PopupMenuDivider(),

          // Edit
          PopupMenuItem<void>(
            onTap: () => context.pushRoute(const ProfileEditRoute()),
            child: const Text('Edit profile'),
          ),
          const PopupMenuDivider(),

          // Theme
          const PopupMenuItem<void>(
            child: ThemeSwitchButton(),
          ),
          const PopupMenuDivider(),

          // Intro
          PopupMenuItem<void>(
            onTap: () => GetIt.I<SettingsCubit>().setIntroEnabled(true),
            child: const Text('Show intro again'),
          ),
          const PopupMenuDivider(),

          //Logout
          PopupMenuItem<void>(
            onTap: GetIt.I<AuthCubit>().signOut,
            child: const Text('Logout'),
          ),
        ],
      );
}
