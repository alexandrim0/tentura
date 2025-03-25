import 'package:flutter/material.dart';
import 'package:tentura_root/i10n/I10n.dart';

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
        title: Text(I10n.of(context)!.labelConfirmation),
        content: Text(I10n.of(context)!.topicRemovalMessage(contextName)),
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
