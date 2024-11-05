import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../widget/qr_code.dart';

class ShareCodeDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String header,
    required Uri link,
  }) =>
      showDialog(
        context: context,
        builder: (context) => ShareCodeDialog(
          header: header,
          link: link.toString(),
        ),
      );

  final String header;
  final String link;

  const ShareCodeDialog({
    required this.header,
    required this.link,
    super.key,
  });

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
        header,
        maxLines: 1,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineMedium,
      ),

      // QRCode
      content: QrCode(
        data: header,
      ),

      // Buttons
      actions: [
        TextButton(
          child: const Text('Copy to clipboard'),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: link));
            if (context.mounted) {
              showSnackBar(
                context,
                text: 'Seed copied to clipboard!',
              );
            }
          },
        ),
        Builder(
          builder: (context) => TextButton(
            child: const Text('Share Link'),
            onPressed: () {
              final box = context.findRenderObject()! as RenderBox;
              Share.share(
                link,
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
              );
            },
          ),
        ),
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
