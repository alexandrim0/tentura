import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../widget/profile_navbar_item.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
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
              icon: Icon(Icons.contacts_outlined),
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
      );
}
