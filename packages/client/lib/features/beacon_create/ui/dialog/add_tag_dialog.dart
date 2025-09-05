import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';

class BeaconAddTagDialog extends StatefulWidget {
  static Future<String?> show(BuildContext context) => showDialog<String>(
    context: context,
    builder: (_) => const BeaconAddTagDialog(),
  );

  const BeaconAddTagDialog({super.key});

  @override
  State<BeaconAddTagDialog> createState() => _BeaconAddTagDialogState();
}

class _BeaconAddTagDialogState extends State<BeaconAddTagDialog> {
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog.adaptive(
      // TBD: l10n
      title: const Text('Add tag'),
      titleTextStyle: textTheme.headlineLarge,
      content: TextField(
        autofocus: true,
        controller: _tagController,
        decoration: const InputDecoration(
          // TBD: l10n
          hintText: 'Enter tag name',
          prefixIcon: Icon(Icons.tag),
        ),
      ),
      contentTextStyle: textTheme.bodyMedium,
      actions: [
        // Yes
        TextButton(
          onPressed: () => Navigator.of(context).pop(_tagController.text),
          child: Text(l10n.buttonYes),
        ),

        // Cancel
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(l10n.buttonCancel),
        ),
      ],
    );
  }
}
