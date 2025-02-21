import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';

import '../utils/ui_utils.dart';
import 'avatar_rated.dart';
import 'tentura_icons.dart';

class AuthorInfo extends StatelessWidget {
  const AuthorInfo({required this.author, this.onTap, super.key});

  final Profile author;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Row(
      children: [
        // Avatar
        Padding(padding: kPaddingAllS, child: AvatarRated(profile: author)),

        // User displayName
        Text(author.title, style: Theme.of(context).textTheme.headlineMedium),

        // An Eye
        Padding(
          padding: kPaddingH,
          child: Icon(
            author.isSeeingMe ? TenturaIcons.eyeOpen : TenturaIcons.eyeClosed,
          ),
        ),
      ],
    ),
  );
}
