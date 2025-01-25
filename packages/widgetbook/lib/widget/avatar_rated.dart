import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';

@UseCase(
  name: 'Default',
  type: AvatarRated,
  path: '[widget]/avatar',
)
Widget avatarRatedUseCase(BuildContext context) {
  return const Center(
    child: Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AvatarRated(
          profile: Profile(),
        ),
        AvatarRated(
          profile: Profile(score: 25),
        ),
        AvatarRated(
          profile: Profile(score: 75),
        ),
        AvatarRated(
          profile: Profile(score: 100),
        ),
      ],
    ),
  );
}
