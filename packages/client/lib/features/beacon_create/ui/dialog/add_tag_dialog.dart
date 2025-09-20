import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/string_input_validator.dart';

class BeaconAddTagDialog extends StatefulWidget {
  static Future<String?> show(BuildContext context) =>
      showAdaptiveDialog<String>(
        context: context,
        builder: (_) => const BeaconAddTagDialog(),
      );

  const BeaconAddTagDialog({super.key});

  @override
  State<BeaconAddTagDialog> createState() => _BeaconAddTagDialogState();
}

class _BeaconAddTagDialogState extends State<BeaconAddTagDialog>
    with StringInputValidator {
  final _tagController = TextEditingController();

  late final _l10n = L10n.of(context)!;

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
      content: TextFormField(
        autofocus: true,
        controller: _tagController,
        decoration: const InputDecoration(
          // TBD: l10n
          hintText: 'Enter tag name',
          prefixIcon: Icon(Icons.tag),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_]')),
        ],
        maxLength: kTitleMaxLength,
        validator: (value) => titleValidator(_l10n, value),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
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
