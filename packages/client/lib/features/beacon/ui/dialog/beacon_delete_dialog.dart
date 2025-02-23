import 'package:flutter/material.dart';

class BeaconDeleteDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) => showDialog(
        context: context,
        builder: (_) => const BeaconDeleteDialog(),
      );

  const BeaconDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
        title: const Text(
          'Are you sure you want to delete this beacon?',
        ),
        actions: [
          // Delete
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),

          // Cancel
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
        ],
      );
}
