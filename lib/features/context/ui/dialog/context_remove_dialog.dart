import 'package:flutter/material.dart';

class ContextRemoveDialog extends StatelessWidget {
  static Future<bool?> show(
    BuildContext context, {
    required String contextName,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (_) => ContextRemoveDialog(contextName: contextName),
      );

  const ContextRemoveDialog({
    required this.contextName,
    super.key,
  });

  final String contextName;

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
        title: const Text('Are you sure?'),
        content: Text('Topic $contextName will be removed from your list!'),
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
