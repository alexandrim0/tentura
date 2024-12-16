import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/theme.dart';

@UseCase(
  name: 'Default',
  type: AvatarRated,
)
Widget colorsDrawerUseCase(BuildContext context) {
  return Theme(
    data: themeDark,
    child: const Center(
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarRated(
            profile: Profile(),
          ),
          AvatarRated(
            profile: Profile(score: 0.2),
          ),
          AvatarRated(
            profile: Profile(score: 0.6),
          ),
          AvatarRated(
            profile: Profile(score: 1),
          ),
        ],
      ),
    ),
  );
}
