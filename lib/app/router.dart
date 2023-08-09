import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:gravity/data/auth_repository.dart';
import 'package:gravity/ui/screens/error_screen.dart';
import 'package:gravity/features/home/home_screen.dart';
import 'package:gravity/features/auth/login_screen.dart';
import 'package:gravity/features/connect/connect_screen.dart';
import 'package:gravity/features/updates/updates_screen.dart';
import 'package:gravity/features/my_field/my_field_screen.dart';
import 'package:gravity/features/profile/profile_view_screen.dart';
import 'package:gravity/features/profile/profile_edit_screen.dart';
import 'package:gravity/features/beacon_create/beacon_create_screen.dart';
import 'package:gravity/features/beacon_details/beacon_details_screen.dart';

export 'package:go_router/go_router.dart';

const pathLogin = '/login';
const pathField = '/field';
const pathConnect = '/connect';
const pathUpdates = '/updates';
const pathProfile = '/profile';
const pathProfileView = '/profile/view';
const pathProfileEdit = '/profile/edit';
const pathBeaconCreate = '/beacon/create';
const pathBeaconDetails = '/beacon/details';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');

final router = GoRouter(
  initialLocation: pathLogin,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: kDebugMode,
  observers: [SentryNavigatorObserver()],
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  redirect: (context, state) =>
      GetIt.I<AuthRepository>().isAuthenticated ? null : pathLogin,
  routes: [
    GoRoute(
      path: pathLogin,
      redirect: (context, state) =>
          GetIt.I<AuthRepository>().isAuthenticated ? pathField : null,
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      path: pathProfile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProfileViewScreen(),
    ),
    GoRoute(
      path: pathProfileEdit,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProfileEditScreen(),
    ),
    GoRoute(
      path: pathBeaconCreate,
      builder: (context, state) => const BeaconCreateScreen(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    GoRoute(
      path: pathBeaconDetails,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BeaconDetailsScreen(),
    ),
    ShellRoute(
      navigatorKey: homeNavigatorKey,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state, child) => HomeScreen(
        path: state.path,
        child: child,
      ),
      routes: [
        GoRoute(
          path: pathField,
          parentNavigatorKey: homeNavigatorKey,
          builder: (context, state) => const MyFieldScreen(),
        ),
        GoRoute(
          path: pathConnect,
          parentNavigatorKey: homeNavigatorKey,
          builder: (context, state) => const ConnectScreen(),
        ),
        GoRoute(
          path: pathUpdates,
          parentNavigatorKey: homeNavigatorKey,
          builder: (context, state) => const UpdatesScreen(),
        ),
        GoRoute(
          path: pathProfileView,
          parentNavigatorKey: homeNavigatorKey,
          builder: (context, state) => const ProfileViewScreen(),
        ),
      ],
    ),
  ],
);
