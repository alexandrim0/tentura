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
  RootRouter(
    this._logger,
    this._authCubit,
    this._settingsCubit,
  );

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
      path: kPathHome,
      children: [
        // Field
        AutoRoute(
          page: MyFieldRoute.page,
          path: kPathMyField.split('/').last,
        ),
        // Favorites
        AutoRoute(
          page: FavoritesRoute.page,
          path: kPathFavorites.split('/').last,
        ),
        // Connect
        AutoRoute(
          page: ConnectRoute.page,
          path: kPathConnect.split('/').last,
        ),
        // Friends
        AutoRoute(
          page: FriendsRoute.page,
          path: kPathFriends.split('/').last,
        ),
        // Profile
        AutoRoute(
          initial: true,
          page: ProfileRoute.page,
          path: kPathProfile.split('/').last,
        ),
      ],
      guards: [
        AutoRouteGuard.redirect(
          (_) => _settingsCubit.state.introEnabled ? const IntroRoute() : null,
        ),
        AutoRouteGuard.redirect(
          (_) => _authCubit.state.isNotAuthenticated
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
          (_) =>
              _settingsCubit.state.introEnabled ? null : const AuthLoginRoute(),
        ),
      ],
    ),

    // Login
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      page: AuthLoginRoute.page,
      path: kPathSignIn,
      guards: [
        AutoRouteGuard.redirect(
          (_) => _authCubit.state.isAuthenticated ? const ProfileRoute() : null,
        ),
      ],
    ),

    // Profile Register
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      fullscreenDialog: true,
      page: AuthRegisterRoute.page,
      path: kPathSignUp,
      guards: [
        AutoRouteGuard.redirect(
          (_) => _authCubit.state.isAuthenticated ? const ProfileRoute() : null,
        ),
      ],
    ),

    // Invitations
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      fullscreenDialog: true,
      page: InvitationRoute.page,
      path: kPathInvitations,
    ),

    // Profile View
    AutoRoute(
      fullMatch: true,
      usesPathAsKey: true,
      maintainState: false,
      page: ProfileViewRoute.page,
      path: '$kPathProfileView/:id',
      guards: [
        AutoRouteGuard.redirect(
          (r) => _authCubit.checkIfIsMe(r.route.params.getString('id'))
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
      path: '$kPathBeaconView/:id',
    ),

    // Beacon View All
    AutoRoute(
      maintainState: false,
      page: BeaconRoute.page,
      path: '$kPathBeaconViewAll/:id',
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
      path: '$kPathGraph/:id',
      //
    ),

    // Chat
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      page: ChatRoute.page,
      path: '$kPathChat/:id',
      guards: [
        AutoRouteGuard.redirect(
          (_) => _authCubit.state.isNotAuthenticated
              ? const AuthLoginRoute()
              : null,
        ),
        AutoRouteGuard.redirect(
          (resolver) {
            final receiverId = resolver.route.queryParams.getString(
              'receiver_id',
              '',
            );
            if (receiverId.isNotEmpty &&
                _authCubit.state.currentAccountId != receiverId) {
              unawaited(_authCubit.signOut());
            }
            return null;
          },
        ),
      ],
    ),

    // Complaint
    AutoRoute(
      keepHistory: false,
      maintainState: false,
      fullscreenDialog: true,
      page: ComplaintRoute.page,
      path: '$kPathComplaint/:id',
    ),

    // default
    RedirectRoute(
      path: '*',
      redirectTo: kPathHome,
    ),
  ];

  FutureOr<DeepLink> deepLinkBuilder(PlatformDeepLink deepLink) {
    _logger.i('DeepLinkBuilder: ${deepLink.uri}');
    return deepLink;
  }

  Future<Uri> deepLinkTransformer(Uri uri) => SynchronousFuture(
    uri.path == kPathAppLinkView
        ? uri.replace(
            path: switch (uri.queryParameters['id']) {
              final String id when id.startsWith('B') || id.startsWith('C') =>
                '$kPathBeaconView/$id',
              final String id when id.startsWith('O') || id.startsWith('U') =>
                '$kPathProfileView/$id',
              final String id when id.startsWith('I') =>
                _authCubit.state.isAuthenticated
                    ? kPathConnect
                    : _authCubit.state.accounts.isEmpty
                    ? kPathSignUp
                    : kPathSignIn,
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
      unawaited(subscription.cancel());
    }
    super.dispose();
  }
}
