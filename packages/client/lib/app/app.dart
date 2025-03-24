import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:localization/localization.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/theme.dart';

import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';

import 'di/di.dart';

class App extends StatelessWidget {
  static Future<void> runner() async {
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
          title: 'Tentura',
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          routerConfig: router.config(
            deepLinkBuilder: router.deepLinkBuilder,
            deepLinkTransformer: router.deepLinkTransformer,
            navigatorObservers: () => [GetIt.I<SentryNavigatorObserver>()],
            reevaluateListenable: router.reevaluateListenable,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            if (child == null) return const SizedBox();
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(textScaler: TextScaler.noScaling),
              child:
                  kIsWeb && media.orientation == Orientation.landscape
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
}
