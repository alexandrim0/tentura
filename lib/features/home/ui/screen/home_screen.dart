import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/chat/ui/bloc/chat_news_cubit.dart';

import '../widget/friends_navbar_item.dart';
import '../widget/profile_navbar_item.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: [
          // Auth
          BlocListener<AuthCubit, AuthState>(
            bloc: GetIt.I<AuthCubit>(),
            listener: showSnackBarError,
            listenWhen: (_, c) => c.hasError,
          ),

          // ChatNews
          BlocListener<ChatNewsCubit, ChatNewsState>(
            bloc: GetIt.I<ChatNewsCubit>(),
            listener: showSnackBarError,
            listenWhen: (_, c) => c.hasError,
          ),
        ],

        // Home Scaffold
        child: AutoTabsScaffold(
          bottomNavigationBuilder: (context, tabsRouter) => NavigationBar(
            onDestinationSelected: tabsRouter.setActiveIndex,
            selectedIndex: tabsRouter.activeIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(TenturaIcons.home),
                label: 'My field',
              ),
              NavigationDestination(
                icon: Icon(Icons.star_border),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(Icons.cable),
                label: 'Connect',
              ),
              // NavigationDestination(
              //   icon: Icon(TenturaIcons.updates),
              //   label: 'Updates',
              // ),
              NavigationDestination(
                icon: FriendsNavbarItem(),
                label: 'Friends',
              ),
              NavigationDestination(
                icon: ProfileNavBarItem(),
                label: 'Profile',
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          routes: const [
            MyFieldRoute(),
            FavoritesRoute(),
            ConnectRoute(),
            // UpdatesRoute(),
            FriendsRoute(),
            ProfileMineRoute(),
          ],
        ),
      );
}
