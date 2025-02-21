import 'package:flutter/material.dart';

class OpinionDeleteDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const OpinionDeleteDialog());

  const OpinionDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: const Text('Are you sure you want to delete this opinion?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Yes'),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: const Text('Cancel'),
      ),
    ],
  );
}
