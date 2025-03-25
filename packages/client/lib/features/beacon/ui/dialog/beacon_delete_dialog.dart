import 'package:flutter/material.dart';
import 'package:tentura_root/i10n/I10n.dart';

class BeaconDeleteDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const BeaconDeleteDialog());

  const BeaconDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(I10n.of(context)!.confirmBeaconRemoval),
    actions: [
      // Delete
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(I10n.of(context)!.buttonDelete),
      ),

      // Cancel
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(I10n.of(context)!.buttonCancel),
      ),
    ],
  );
}
