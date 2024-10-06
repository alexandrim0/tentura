import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_image.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

class BeaconAuthorInfo extends StatelessWidget {
  const BeaconAuthorInfo({
    required this.author,
    super.key,
  });

  final Profile author;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => context.pushRoute(
        ProfileViewRoute(id: author.id),
      ),
      child: Row(
        children: [
          // Avatar
          Padding(
            padding: const EdgeInsets.only(right: kSpacingSmall),
            child: AvatarImage(
              userId: author.imageId,
              size: 40,
            ),
          ),
          // User displayName
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.pushRoute(
                  ProfileViewRoute(id: author.id),
                ),
                child: Text(
                  author.title,
                  style: textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
