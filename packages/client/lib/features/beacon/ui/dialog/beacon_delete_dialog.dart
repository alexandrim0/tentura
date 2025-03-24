import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class BeaconDeleteDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const BeaconDeleteDialog());

  const BeaconDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(AppLocalizations.of(context)!.confirmBeaconRemoval),
    actions: [
      // Delete
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(AppLocalizations.of(context)!.buttonDelete),
      ),

      // Cancel
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(AppLocalizations.of(context)!.buttonCancel),
      ),
    ],
  );
}
