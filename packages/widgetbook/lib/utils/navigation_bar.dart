import 'package:flutter/material.dart';
import 'package:tentura/features/home/ui/widget/friends_navbar_item.dart';
import 'package:tentura/features/home/ui/widget/profile_navbar_item.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

NavigationBar buildNavigationBar({required int index}) => NavigationBar(
        selectedIndex: 4,
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
            icon: Icon(TenturaIcons.affiliation),
            label: 'Connect',
          ),
          NavigationDestination(
            icon: FriendsNavbarItem(),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: ProfileNavBarItem(),
            label: 'Profile',
          ),
        ],
      );
