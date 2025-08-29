import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';

@UseCase(
  name: 'Default',
  type: AvatarRated,
  path: '[widget]',
)
Widget avatarRatedUseCase(BuildContext context) => Center(
  child: Column(
    spacing: 16,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      AvatarRated.small(profile: const Profile()),
      AvatarRated.small(profile: const Profile(score: 25)),
      AvatarRated.small(profile: const Profile(score: 75)),
      AvatarRated.small(profile: const Profile(score: 100)),
    ],
  ),
);
