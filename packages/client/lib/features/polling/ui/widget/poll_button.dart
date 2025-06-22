import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/polling.dart';
import 'package:tentura/ui/l10n/l10n.dart';

import '../dialog/poll_dialog.dart';

class PollButton extends StatelessWidget {
  const PollButton({this.polling, super.key});

  final Polling? polling;

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.poll),
    tooltip: L10n.of(context)!.showPollButton,
    onPressed: polling == null
        ? null
        : () => PollDialog.show(context, polling: polling!),
  );
}
