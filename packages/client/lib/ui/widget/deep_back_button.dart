import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';

class DeepBackButton extends StatelessWidget {
  const DeepBackButton({
    this.path = kPathHome,
    super.key,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    return router.canNavigateBack
        ? const AutoLeadingButton()
        : BackButton(
            onPressed: () => router.navigatePath(path),
          );
  }
}
