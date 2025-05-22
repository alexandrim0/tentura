import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

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
          try {
            final router = AutoRouter.of(context);
            if (await router.maybePopTop()) return;
            if (context.mounted) await router.navigate(backRoute);
          } catch (e) {
            GetIt.I<Logger>().w('Can`t find AutoRouter');
          }
        },
      );
}
