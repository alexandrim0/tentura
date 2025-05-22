import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/features/connect/ui/screen/connect_screen.dart';
import 'package:tentura/features/favorites/ui/screen/favorites_screen.dart';
import 'package:tentura/features/friends/ui/screen/friends_screen.dart';
import 'package:tentura/features/home/ui/widget/friends_navbar_item.dart';
import 'package:tentura/features/home/ui/widget/profile_navbar_item.dart';
import 'package:tentura/features/my_field/ui/screen/my_field_screen.dart';
import 'package:tentura/features/profile/ui/screen/profile_screen.dart';

import 'package:tentura/ui/widget/tentura_icons.dart';

@UseCase(name: 'Default', type: HomeScreen, path: '[screen]/home')
Widget defaultHomeUseCase(BuildContext context) => const HomeScreen();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body:
        const [
          MyFieldScreen(),
          FavoritesScreen(),
          ConnectScreen(),
          FriendsScreen(),
          ProfileScreen(),
        ][_selectedIndex],
    bottomNavigationBar: NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(TenturaIcons.home), label: 'My field'),
        NavigationDestination(
          icon: Icon(Icons.star_border),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(TenturaIcons.affiliation),
          label: 'Connect',
        ),
        NavigationDestination(icon: FriendsNavbarItem(), label: 'Friends'),
        NavigationDestination(icon: ProfileNavBarItem(), label: 'Profile'),
      ],
      onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      selectedIndex: _selectedIndex,
    ),
  );
}
