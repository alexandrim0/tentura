import 'dart:async';
import 'package:logger/logger.dart';
import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';

import 'root_router.gr.dart';

export 'package:auto_route/auto_route.dart';

export 'root_router.gr.dart';

@singleton
@AutoRouterConfig()
class RootRouter extends RootStackRouter {
  RootRouter(this._logger, this._authCubit, this._settingsCubit);

  late final reevaluateListenable = _ReevaluateFromStreams([
    _settingsCubit.stream.map((e) => e.introEnabled),
    _authCubit.stream.map((e) => e.currentAccount),
  ]);

  final Logger _logger;

  final AuthCubit _authCubit;

  final SettingsCubit _settingsCubit;

  @override
  @disposeMethod
  void dispose() {
    reevaluateListenable.dispose();
    super.dispose();
  }

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    // Home
    AutoRoute(
      initial: true,
      page: HomeRoute.page,
      path: kPathRoot,
      children: [
        // Field
        AutoRoute(page: MyFieldRoute.page),
        // Favorites
        AutoRoute(page: FavoritesRoute.page),
        // Connect
        AutoRoute(page: ConnectRoute.page),
        // Friends
        AutoRoute(page: FriendsRoute.page),
        // Profile
        AutoRoute(initial: true, page: ProfileRoute.page),
      ],
      guards: [
        AutoRouteGuard.redirect(
          (resolver) =>
              _settingsCubit.state.introEnabled ? const IntroRoute() : null,
        ),
        AutoRouteGuard.redirect(
          (resolver) =>
              _authCubit.state.isNotAuthenticated
                  ? const AuthLoginRoute()
                  : null,
        ),
      ],
    ),

    // Intro
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      page: IntroRoute.page,
      guards: [
        AutoRouteGuard.redirect(
          (resolver) =>
              _settingsCubit.state.introEnabled ? null : const AuthLoginRoute(),
        ),
      ],
    ),

    // Login
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      page: AuthLoginRoute.page,
      guards: [
        AutoRouteGuard.redirect(
          (resolver) =>
              _authCubit.state.isAuthenticated
                  ? (_authCubit.state.currentAccount.needEdit
                      ? const ProfileEditRoute()
                      : const ProfileRoute())
                  : null,
        ),
      ],
    ),

    // Profile View
    AutoRoute(
      maintainState: false,
      page: ProfileViewRoute.page,
      path: kPathProfileView,
      guards: [
        AutoRouteGuard.redirect(
          (r) =>
              _authCubit.checkIfIsMe(r.route.queryParams.getString('id'))
                  ? const ProfileRoute()
                  : null,
        ),
      ],
    ),

    // Profile Edit
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      fullscreenDialog: true,
      page: ProfileEditRoute.page,
      path: kPathProfileEdit,
    ),

    // Settings
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      fullscreenDialog: true,
      page: SettingsRoute.page,
      path: kPathSettings,
    ),

    // Beacon Create New
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      fullscreenDialog: true,
      page: BeaconCreateRoute.page,
      path: kPathBeaconNew,
    ),

    // Beacon View
    AutoRoute(
      maintainState: false,
      page: BeaconViewRoute.page,
      path: kPathBeaconView,
    ),

    // Beacon View All
    AutoRoute(
      maintainState: false,
      page: BeaconRoute.page,
      path: kPathBeaconViewAll,
    ),

    // Rating
    AutoRoute(
      maintainState: false,
      page: RatingRoute.page,
      path: kPathRating,
      //
    ),

    // Graph
    AutoRoute(
      maintainState: false,
      page: GraphRoute.page,
      path: kPathGraph,
      //
    ),

    // Chat
    AutoRoute(
      maintainState: false,
      page: ChatRoute.page,
      path: kPathProfileChat,
    ),

    // Complaint
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      fullscreenDialog: true,
      page: ComplaintRoute.page,
      path: kPathComplaint,
    ),

    // default
    RedirectRoute(path: '*', redirectTo: kPathRoot),
  ];

  FutureOr<DeepLink> deepLinkBuilder(PlatformDeepLink deepLink) {
    _logger.i('DeepLinkBuilder: ${deepLink.uri}');
    return deepLink;
  }

  Future<Uri> deepLinkTransformer(Uri uri) => SynchronousFuture(
    uri.path == kPathAppLinkView
        ? uri.replace(
          path: switch (uri.queryParameters['id']) {
            final String id when id.startsWith('U') => kPathProfileView,
            final String id when id.startsWith('B') => kPathBeaconView,
            final String id when id.startsWith('C') => kPathBeaconView,
            _ => kPathConnect,
          },
        )
        : uri,
  );
}

class _ReevaluateFromStreams extends ChangeNotifier {
  final _subscriptions = <StreamSubscription<dynamic>>[];

  _ReevaluateFromStreams(List<Stream<dynamic>> streams) {
    for (final stream in streams) {
      _subscriptions.add(stream.listen((_) => notifyListeners()));
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
