import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class OpinionPublishDialog extends StatelessWidget {
  static Future<int?> show(BuildContext context) => showDialog(
    context: context,
    builder: (_) => const OpinionPublishDialog(),
  );

  const OpinionPublishDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(AppLocalizations.of(context)!.positiveOrNegativeOpinion),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(1),
        child: Text(AppLocalizations.of(context)!.positiveOpinion),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(-1),
        child: Text(AppLocalizations.of(context)!.negativeOpinion),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(AppLocalizations.of(context)!.buttonCancel),
      ),
    ],
  );
}
