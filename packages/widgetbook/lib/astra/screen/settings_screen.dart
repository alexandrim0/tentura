import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/ui/dialog/show_seed_dialog.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';

import '../widget/theme_astra.dart';

@UseCase(
  name: 'Default',
  type: SettingScreen,
  path: '[astra]/screen',
)
Widget settingsUseCase(BuildContext context) => const SettingScreen();

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) => ThemeAstra(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: const DeepBackButton(),
      ),
      body: Padding(
        padding: kPaddingAll,
        child: Column(
          spacing: kSpacingMedium,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.remove_red_eye_outlined),
                label: const Text('Show Seed'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final authCubit = GetIt.I<AuthCubit>();
                  final accountId = authCubit.state.currentAccountId;
                  final seed = await authCubit.getSeedByAccountId(accountId);
                  if (context.mounted) {
                    await ShowSeedDialog.show(
                      context,
                      seed: seed,
                    );
                  }
                },
              ),
            ),

            // const ThemeSwitchButton(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.reset_tv),
                label: const Text('Show Intro Again'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
              ),
            ),

            //Logout
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.people),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
