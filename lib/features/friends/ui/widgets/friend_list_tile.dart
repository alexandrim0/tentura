import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/widget/avatar_image.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

import '../dialog/friend_remove_dialog.dart';

class FriendListTile extends StatelessWidget {
  const FriendListTile({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.pushRoute(
        ProfileViewRoute(id: profile.id),
      ),
      child: ListTile(
        // Avatar
        leading: AvatarImage(
          userId: profile.id,
          size: 40,
        ),

        // Title
        title: Text(
          profile.title,
        ),

        // More button
        trailing: IconButton(
          icon: const Icon(Icons.person_remove_outlined),
          onPressed: () => FriendRemoveDialog.show(context, profile: profile),
        ),
      ),
    );
  }
}
