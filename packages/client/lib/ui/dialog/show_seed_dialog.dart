import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/qr_code.dart';

class ShowSeedDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String accountId,
    required String seed,
  }) =>
      showDialog(
        context: context,
        builder: (context) => ShowSeedDialog(
          accountId: accountId,
          seed: seed,
        ),
      );

  const ShowSeedDialog({
    required this.accountId,
    required this.seed,
    super.key,
  });

  final String accountId;
  final String seed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog.adaptive(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      titlePadding: kPaddingAll,
      contentPadding: kPaddingAll,
      backgroundColor: theme.colorScheme.surfaceBright,

      // Header
      title: Text(
        seed,
        maxLines: 1,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineMedium,
      ),

      // QRCode
      content: QrCode(
        data: seed,
      ),

      // Buttons
      actions: [
        TextButton(
          child: const Text('Copy to clipboard'),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: seed));
            if (context.mounted) {
              showSnackBar(
                context,
                text: 'Seed copied to clipboard!',
              );
            }
          },
        ),
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
