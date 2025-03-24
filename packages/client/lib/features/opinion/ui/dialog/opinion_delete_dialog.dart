import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class OpinionDeleteDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const OpinionDeleteDialog());

  const OpinionDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(AppLocalizations.of(context)!.confirmOpinionRemoval),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(AppLocalizations.of(context)!.buttonYes),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(AppLocalizations.of(context)!.buttonCancel),
      ),
    ],
  );
}
