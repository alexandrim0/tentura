import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/ui/theme.dart';

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
          devices: [
            ...Devices.android.all,
            ...Devices.ios.all,
          ],
          initialDevice: Devices.ios.iPhone13ProMax,
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Dark',
              data: themeDark,
            ),
            WidgetbookTheme(
              name: 'Light',
              data: themeLight,
            ),
          ],
        )
      ],
    );
  }
}
