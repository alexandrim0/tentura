import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

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
                text: 'Not implemented yet...',
              ),
              child: const Text('Mark all as read'),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: kPaddingH,
            child: Text(
              'There is nothing here yet',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
