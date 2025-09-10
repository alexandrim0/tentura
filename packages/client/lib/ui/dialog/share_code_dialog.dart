import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../widget/qr_code.dart';

class ShareCodeDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String header,
    // TBD: get id only, build link here
    required Uri link,
  }) => showDialog(
    context: context,
    builder: (_) => ShareCodeDialog(
      header: header,
      link: link.toString(),
    ),
  );

  const ShareCodeDialog({
    required this.header,
    required this.link,
    super.key,
  });

  final String header;
  final String link;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context)!;
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
      content: QrCode(data: link),

      // Buttons
      actions: [
        TextButton(
          child: Text(l10n.copyToClipboard),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: link));
            if (context.mounted) {
              showSnackBar(
                context,
                // TBD: l10n
                text: 'Link copied into clipboard.',
              );
            }
          },
        ),
        Builder(
          builder: (context) => TextButton(
            child: Text(l10n.shareLink),
            onPressed: () {
              final box = context.findRenderObject()! as RenderBox;
              SharePlus.instance.share(
                ShareParams(
                  uri: Uri.parse(link),
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size,
                ),
              );
            },
          ),
        ),
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(l10n.buttonClose),
        ),
      ],
    );
  }
}
