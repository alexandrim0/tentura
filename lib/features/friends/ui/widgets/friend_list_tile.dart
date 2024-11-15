import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/widget/avatar_image.dart';

import '../dialog/friend_remove_dialog.dart';

class FriendListTile extends StatelessWidget {
  const FriendListTile({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Avatar
      leading: GestureDetector(
        onTap: () => context.pushRoute(
          ProfileViewRoute(id: profile.id),
        ),
        child: AvatarImage(
          userId: profile.id,
          size: 40,
        ),
      ),

      // Title
      title: Text(profile.title),
      onTap: () => context.pushRoute(
        ChatRoute(id: profile.id),
      ),

      // Remove from friends list
      trailing: IconButton(
        icon: const Icon(Icons.person_remove_outlined),
        onPressed: () => FriendRemoveDialog.show(
          context,
          profile: profile,
        ),
      ),
    );
  }
}
