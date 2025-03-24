import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

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
      title: Text(AppLocalizations.of(context)!.confirmBeaconPublishing),
      titleTextStyle: textTheme.headlineLarge,
      content: Text(AppLocalizations.of(context)!.confirmBeaconPublishingHint),
      contentTextStyle: textTheme.bodyMedium,
      actions: [
        // Yes
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.buttonYes),
        ),

        // Cancel
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(AppLocalizations.of(context)!.buttonCancel),
        ),
      ],
    );
  }
}
