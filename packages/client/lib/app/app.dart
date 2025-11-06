import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/theme.dart';

import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';

import 'di/di.dart';
import 'di/globals.dart';
import 'platform/lifecycle_handler.dart';
import 'router/root_router.dart';

class App extends StatelessWidget {
  static Future<void> runner() async {
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await configureDependencies();
    FlutterNativeSplash.remove();
    runApp(
      const Globals(
        child: LifecycleHandler(
          child: App(),
        ),
      ),
    );
  }

  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<SettingsCubit, SettingsState, ThemeMode>(
        bloc: GetIt.I<SettingsCubit>(),
        selector: (state) => state.themeMode,
        builder: (_, themeMode) {
          final router = GetIt.I<RootRouter>();
          return MaterialApp.router(
            title: kAppTitle,
            theme: createAppTheme(colorSchemeLight),
            darkTheme: createAppTheme(colorSchemeDark),
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: router.config(
              deepLinkBuilder: router.deepLinkBuilder,
              deepLinkTransformer: router.deepLinkTransformer,
              reevaluateListenable: router.reevaluateListenable,
              navigatorObservers: () => [
                GetIt.I<SentryNavigatorObserver>(),
              ],
            ),
            supportedLocales: L10n.supportedLocales,
            localizationsDelegates: L10n.localizationsDelegates,
            onGenerateTitle: (context) =>
                L10n.of(context)?.appTitle ?? kAppTitle,
            builder: (context, child) {
              if (child == null) {
                return const SizedBox();
              }
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: kIsWeb && media.orientation == Orientation.landscape
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
                    : child,
              );
            },
          );
        },
      );
}
