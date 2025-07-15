import 'dart:async';
// import 'package:web/web.dart';
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
import 'router/root_router.dart';

class App extends StatefulWidget {
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
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AppLifecycleListener? _appLifecycleListener;
  // StreamSubscription<Event>? _webEvents;

  late final _router = GetIt.I<RootRouter>();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // _webEvents = document.onVisibilityChange.listen(
      //   (event) {},
      // );
    } else {
      _appLifecycleListener = AppLifecycleListener();
    }
  }

  @override
  Future<void> dispose() async {
    _appLifecycleListener?.dispose();
    // await _webEvents?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocSelector<SettingsCubit, SettingsState, ThemeMode>(
        bloc: GetIt.I<SettingsCubit>(),
        selector: (state) => state.themeMode,
        builder: (_, themeMode) => MaterialApp.router(
          title: kAppTitle,
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: _router.config(
            deepLinkBuilder: _router.deepLinkBuilder,
            deepLinkTransformer: _router.deepLinkTransformer,
            reevaluateListenable: _router.reevaluateListenable,
            navigatorObservers: () => [
              GetIt.I<SentryNavigatorObserver>(),
            ],
          ),
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: L10n.localizationsDelegates,
          onGenerateTitle: (context) => L10n.of(context)?.appTitle ?? kAppTitle,
          builder: (context, child) {
            if (child == null) {
              return const SizedBox();
            }
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(textScaler: TextScaler.noScaling),
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
        ),
      );
}
