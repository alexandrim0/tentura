import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';

class DeepBackButton extends StatelessWidget {
  const DeepBackButton({
    this.path = kPathHome,
    this.color,
    super.key,
  });

  final String path;

  final Color? color;

  @override
  Widget build(BuildContext context) => BackButton(
    color: color,
    onPressed: () async {
      final router = AutoRouter.of(context);
      if (kIsWeb || router.canNavigateBack) {
        router.back();
      } else {
        await router.navigatePath(path);
      }
    },
  );
}
