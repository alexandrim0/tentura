import 'package:flutter/material.dart';

class CommunityInfo extends StatelessWidget {
  const CommunityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.group_outlined,
              size: 16,
            ),
          ),
          Text(
            'Коммьюнити название большое',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
