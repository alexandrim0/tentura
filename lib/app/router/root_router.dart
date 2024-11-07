import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';
import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';

import 'root_router.gr.dart';

export 'package:auto_route/auto_route.dart';

export 'root_router.gr.dart';

const pathRoot = '/';
const pathConnect = '/connect';
const pathBeaconView = '/beacon/view';
const pathProfileChat = '/profile/chat';
const pathProfileView = '/profile/view';
const pathAppLinkView = '/shared/view';

@singleton
@AutoRouterConfig()
class RootRouter extends RootStackRouter {
  RootRouter({
    required ProfileCubit profileCubit,
    required SettingsCubit settingsCubit,
  })  : _profileCubit = profileCubit,
        _settingsCubit = settingsCubit;

  late final reevaluateListenable = _ReevaluateFromStreams([
    _settingsCubit.stream.map((e) => e.introEnabled),
    _profileCubit.stream,
  ]);

  final ProfileCubit _profileCubit;
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
          path: pathRoot,
          page: HomeRoute.page,
          children: [
            // Field
            AutoRoute(
              page: MyFieldRoute.page,
            ),
            // Favorites
            AutoRoute(
              page: FavoritesRoute.page,
            ),
            // Connect
            AutoRoute(
              page: ConnectRoute.page,
            ),
            // Updates
            // AutoRoute(
            //   page: UpdatesRoute.page,
            // ),
            // Friends
            AutoRoute(
              page: FriendsRoute.page,
            ),
            // Profile
            AutoRoute(
              initial: true,
              page: ProfileMineRoute.page,
            ),
          ],
          guards: [
            AutoRouteGuard.redirect(
              (resolver) =>
                  _settingsCubit.state.introEnabled ? const IntroRoute() : null,
            ),
            AutoRouteGuard.redirect(
              (resolver) => _profileCubit.state.isNotAuthorized
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
              (resolver) => _settingsCubit.state.introEnabled
                  ? null
                  : const AuthLoginRoute(),
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
              (resolver) => _profileCubit.state.isNotSuccess
                  ? null
                  : _profileCubit.state.profile.needEdit
                      ? const ProfileEditRoute()
                      : const ProfileMineRoute(),
            ),
          ],
        ),

        // Profile View
        AutoRoute(
          keepHistory: false,
          maintainState: false,
          path: pathProfileView,
          page: ProfileViewRoute.page,
          guards: [
            AutoRouteGuard.redirect(
              (r) =>
                  _profileCubit.checkIfIsMe(r.route.queryParams.getString('id'))
                      ? const ProfileMineRoute()
                      : null,
            ),
          ],
        ),

        // Profile Edit
        AutoRoute(
          keepHistory: false,
          maintainState: false,
          page: ProfileEditRoute.page,
        ),

        // Beacon Create
        AutoRoute(
          keepHistory: false,
          maintainState: false,
          page: BeaconCreateRoute.page,
        ),

        // Beacon View
        AutoRoute(
          keepHistory: false,
          maintainState: false,
          path: pathBeaconView,
          page: BeaconViewRoute.page,
        ),

        // Rating
        AutoRoute(
          keepHistory: false,
          maintainState: false,
          page: RatingRoute.page,
        ),

        // Graph
        AutoRoute(
          keepHistory: false,
          maintainState: false,
          page: GraphRoute.page,
        ),

        // Chat
        AutoRoute(
          keepHistory: false,
          maintainState: false,
          path: pathProfileChat,
          page: ChatRoute.page,
        ),

        // default
        RedirectRoute(
          path: '*',
          redirectTo: pathRoot,
        ),
      ];

  FutureOr<DeepLink> deepLinkBuilder(PlatformDeepLink deepLink) {
    if (kDebugMode) print('DeepLinkBuilder: ${deepLink.uri}');
    return deepLink;
  }

  Future<Uri> deepLinkTransformer(Uri uri) =>
      SynchronousFuture(uri.path == pathAppLinkView
          ? uri.replace(
              path: switch (uri.queryParameters['id']) {
                final String id when id.startsWith('U') => pathProfileView,
                final String id when id.startsWith('B') => pathBeaconView,
                final String id when id.startsWith('C') => pathBeaconView,
                _ => pathConnect,
              },
            )
          : uri);
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
