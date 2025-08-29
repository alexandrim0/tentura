import 'package:flutter/material.dart';

class CommunityInfo extends StatelessWidget {
  const CommunityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.group_outlined, size: 16),
          const SizedBox(width: 4),
          Text(
            'Коммьюнити название большое',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
