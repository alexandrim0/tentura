import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:tentura_root/i10n/I10n.dart';

import '../bloc/settings_cubit.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<SettingsCubit, SettingsState, ThemeMode>(
        bloc: GetIt.I<SettingsCubit>(),
        selector: (state) => state.themeMode,
        builder:
            (_, themeMode) => SegmentedButton<ThemeMode>(
              selected: <ThemeMode>{themeMode},
              showSelectedIcon: false,
              segments: [
                ButtonSegment<ThemeMode>(
                  icon: const Icon(Icons.brightness_7),
                  tooltip: I10n.of(context)!.light,
                  value: ThemeMode.light,
                ),
                ButtonSegment<ThemeMode>(
                  icon: const Icon(Icons.brightness_auto_outlined),
                  tooltip: I10n.of(context)!.system,
                  value: ThemeMode.system,
                ),
                ButtonSegment<ThemeMode>(
                  icon: const Icon(Icons.brightness_5),
                  tooltip: I10n.of(context)!.dark,
                  value: ThemeMode.dark,
                ),
              ],
              onSelectionChanged:
                  (selected) =>
                      GetIt.I<SettingsCubit>().setThemeMode(selected.single),
            ),
      );
}
