import 'package:flutter/material.dart';
import 'package:tentura_root/i10n/I10n.dart';

class OpinionPublishDialog extends StatelessWidget {
  static Future<int?> show(BuildContext context) => showDialog(
    context: context,
    builder: (_) => const OpinionPublishDialog(),
  );

  const OpinionPublishDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    title: Text(I10n.of(context)!.positiveOrNegativeOpinion),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(1),
        child: Text(I10n.of(context)!.positiveOpinion),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(-1),
        child: Text(I10n.of(context)!.negativeOpinion),
      ),
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: Text(I10n.of(context)!.buttonCancel),
      ),
    ],
  );
}
