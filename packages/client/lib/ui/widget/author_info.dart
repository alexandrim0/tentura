import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';

import '../utils/ui_utils.dart';
import 'avatar_rated.dart';
import 'tentura_icons.dart';

class AuthorInfo extends StatelessWidget {
  const AuthorInfo({required this.author, super.key});

  final Profile author;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => context.read<ScreenCubit>().showProfile(author.id),
    child: Row(
      children: [
        // Avatar
        Padding(
          padding: kPaddingAllS,
          child: AvatarRated.small(profile: author),
        ),

        // User displayName
        Text(
          author.title,
          style: Theme.of(context).textTheme.headlineMedium,
          ),

        // An Eye
        Padding(
          padding: kPaddingH,
          child: Icon(
            author.isSeeingMe ? TenturaIcons.eyeOpen : TenturaIcons.eyeClosed,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}
