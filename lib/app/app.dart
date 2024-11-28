import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/theme.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';

import 'di/di.dart';

class App extends StatelessWidget {
  static Future<void> runner() async {
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (kIsWeb) {
      MobileScannerPlatform.instance.setBarcodeLibraryScriptUrl(
        '/packages/zxing.min.js',
      );
    }
    await configureDependencies();
    FlutterNativeSplash.remove();
    runApp(const App());
  }

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, ThemeMode>(
      bloc: GetIt.I<SettingsCubit>(),
      selector: (state) => state.themeMode,
      builder: (context, themeMode) {
        final router = GetIt.I<RootRouter>();
        return MaterialApp.router(
          title: kAppTitle,
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: router.config(
            deepLinkBuilder: router.deepLinkBuilder,
            deepLinkTransformer: router.deepLinkTransformer,
            navigatorObservers: () => [
              GetIt.I<SentryNavigatorObserver>(),
            ],
            reevaluateListenable: router.reevaluateListenable,
          ),
          builder: (context, child) => kIsWeb &&
                  MediaQuery.of(context).orientation == Orientation.landscape
              ? ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: kWebConstraints,
                      child: AspectRatio(
                        aspectRatio: kWebAspectRatio,
                        child: child,
                      ),
                    ),
                  ),
                )
              : child ?? const SizedBox(),
        );
      },
    );
  }
}
