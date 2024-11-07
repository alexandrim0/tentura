import 'package:flutter/material.dart';

class BeaconPublishDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (_) => const BeaconPublishDialog(),
      );

  const BeaconPublishDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog.adaptive(
      title: const Text(
        'Are you sure you want to publish this beacon?',
      ),
      titleTextStyle: textTheme.headlineLarge,
      content: const Text(
        'Once the bacon is published, '
        'it will not be possible to make changes. '
        'Are you sure you want to publish this bacon?',
      ),
      contentTextStyle: textTheme.bodyMedium,
      actions: [
        // Yes
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),

        // Cancel
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
