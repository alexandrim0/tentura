import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/auth_cubit.dart';

class ShowSeedDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String userId,
  }) =>
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => ShowSeedDialog(
          seed: GetIt.I<AuthCubit>().getSeedByAccountId(userId),
          userId: userId,
        ),
      );

  const ShowSeedDialog({
    required this.userId,
    required this.seed,
    super.key,
  });

  final String seed;
  final String userId;

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
        userId,
        maxLines: 1,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineLarge,
      ),

      // QRCode
      content: PrettyQrView.data(
        key: ValueKey(seed),
        data: seed,
        decoration: PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),

      // Buttons
      actions: [
        Builder(
          builder: (context) => TextButton(
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
        ),
        TextButton(
          onPressed: context.maybePop,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
