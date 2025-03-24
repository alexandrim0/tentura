import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:localization/localization.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

@RoutePage()
class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () => showSnackBar(
                context,
                isFloating: true,
                text: AppLocalizations.of(context)!.notImplementedYet,
              ),
              child: Text(AppLocalizations.of(context)!.markAllAsRead),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: kPaddingH,
            child: Text(
              AppLocalizations.of(context)!.labelNothingHere,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
