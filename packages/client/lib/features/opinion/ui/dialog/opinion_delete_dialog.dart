import 'package:flutter/material.dart';
import 'package:tentura_root/i10n/I10n.dart';

class OpinionDeleteDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const OpinionDeleteDialog());

  const OpinionDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(I10n.of(context)!.confirmOpinionRemoval),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(I10n.of(context)!.buttonYes),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(I10n.of(context)!.buttonCancel),
      ),
    ],
  );
}
