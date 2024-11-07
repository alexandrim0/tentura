import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';

class DeepBackButton extends StatelessWidget {
  const DeepBackButton({
    this.backRoute = const HomeRoute(),
    this.color,
    this.style,
    super.key,
  });

  final Color? color;
  final ButtonStyle? style;
  final PageRouteInfo<dynamic> backRoute;

  @override
  Widget build(BuildContext context) => BackButton(
        color: color,
        onPressed: () async {
          if (await context.maybePop()) return;
          if (context.mounted) await context.navigateTo(backRoute);
        },
      );
}
