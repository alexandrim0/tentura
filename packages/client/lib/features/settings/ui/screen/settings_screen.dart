import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura/ui/dialog/show_seed_dialog.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/settings_cubit.dart';
import '../widget/theme_switch_button.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget implements AutoRouteWrapper {
  const SettingsScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocListener<SettingsCubit, SettingsState>(
        listener: commonScreenBlocListener,
        bloc: GetIt.I<SettingsCubit>(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.I<SettingsCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: kPaddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: kSpacingMedium,
          children: [
            const ThemeSwitchButton(),

            // Seed
            ElevatedButton.icon(
              icon: const Icon(Icons.remove_red_eye_outlined),
              label: const Text('Show Seed'),
              onPressed: () async {
                final (:id, :seed) = await cubit.getAccountSeed();
                if (context.mounted) {
                  await ShowSeedDialog.show(context, seed: seed, accountId: id);
                }
              },
            ),

            // Intro
            ElevatedButton.icon(
              icon: const Icon(Icons.reset_tv),
              label: const Text('Show Intro Again'),
              onPressed: () => cubit.setIntroEnabled(true),
            ),

            //Logout
            FilledButton.icon(
              onPressed: cubit.signOut,
              icon: const Icon(Icons.people),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
