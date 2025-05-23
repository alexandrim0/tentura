import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';

class DeepBackButton extends StatelessWidget {
  const DeepBackButton({
    this.path = kPathRoot,
    this.color,
    this.style,
    super.key,
  });

  final String path;

  final Color? color;

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) => BackButton(
    color: color,
    onPressed: () async {
      final router = AutoRouter.of(context);
      if (router.canNavigateBack) {
        router.back();
      } else {
        await router.navigateNamed(path);
      }
    },
  );
}
