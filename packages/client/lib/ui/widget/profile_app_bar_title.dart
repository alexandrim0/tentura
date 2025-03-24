import 'package:flutter/material.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:localization/localization.dart';

class ProfileAppBarTitle extends StatelessWidget {
  const ProfileAppBarTitle({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          profile.title.isEmpty ? AppLocalizations.of(context)!.noName : profile.title,
          style: textTheme.headlineMedium,
        ),

        // ID
        Text(
          profile.id,
          style: textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontSize: textTheme.bodySmall?.fontSize,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
