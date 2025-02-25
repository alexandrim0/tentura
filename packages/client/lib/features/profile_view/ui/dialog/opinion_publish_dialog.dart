import 'package:flutter/material.dart';

class OpinionPublishDialog extends StatelessWidget {
  static Future<int?> show(BuildContext context) => showDialog(
    context: context,
    builder: (_) => const OpinionPublishDialog(),
  );

  const OpinionPublishDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: const Text('Is this opinion is positive or negative?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(1),
        child: const Text('Positive'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(-1),
        child: const Text('Negative'),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: const Text('Cancel'),
      ),
    ],
  );
}
