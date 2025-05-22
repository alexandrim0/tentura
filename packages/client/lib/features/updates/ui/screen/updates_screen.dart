import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

@RoutePage()
class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed:
                () => showSnackBar(
                  context,
                  isFloating: true,
                  text: l10n.notImplementedYet,
                ),
            child: Text(l10n.markAllAsRead),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: kPaddingH,
          child: Text(
            l10n.labelNothingHere,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
