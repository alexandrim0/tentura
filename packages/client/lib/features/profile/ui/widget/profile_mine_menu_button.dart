import 'package:flutter/material.dart';

import 'package:tentura/ui/dialog/show_seed_dialog.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';
import 'package:tentura/features/settings/ui/widget/theme_switch_button.dart';

import '../bloc/profile_cubit.dart';

class ProfileMineMenuButton extends StatelessWidget {
  const ProfileMineMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = GetIt.I<AuthCubit>();
    final profileCubit = GetIt.I<ProfileCubit>();
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry<void>>[
        // Rating
        PopupMenuItem<void>(
          onTap: profileCubit.showRating,
          child: const Text('View rating'),
        ),
        const PopupMenuDivider(),

        // Seed
        PopupMenuItem<void>(
          child: const Text('Show seed'),
          onTap: () async {
            final accountId = authCubit.state.currentAccountId;
            final seed = await authCubit.getSeedByAccountId(accountId);
            if (context.mounted) {
              await ShowSeedDialog.show(
                context,
                seed: seed,
                accountId: accountId,
              );
            }
          },
        ),
        const PopupMenuDivider(),

        // Edit
        PopupMenuItem<void>(
          onTap: profileCubit.showProfileEditor,
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
          onTap: authCubit.signOut,
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
