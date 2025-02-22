import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/ui/theme.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';

import 'app.directories.g.dart';

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      darkTheme: themeDark,
      lightTheme: themeLight,
      directories: directories,
      addons: [
        DeviceFrameAddon(
          devices: [...Devices.android.all, ...Devices.ios.all],
          initialDevice: Devices.ios.iPhone13ProMax,
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Dark', data: themeDark),
            WidgetbookTheme(name: 'Light', data: themeLight),
          ],
        ),
      ],
      appBuilder:
          (_, child) => BlocProvider<ScreenCubit>(
            create: (_) => ScreenCubit(),
            child: BlocListener<ScreenCubit, ScreenState>(
              listenWhen: (_, c) => c.isNavigating || c.hasError,
              // TBD: Navigation
              listener: (context, state) {},
              child: child,
            ),
          ),
    );
  }
}
