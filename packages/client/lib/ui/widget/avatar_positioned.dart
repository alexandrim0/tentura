import 'package:flutter/material.dart';

class AvatarPositioned extends StatelessWidget {
  static const childSize = 200.0;

  final Widget child;

  const AvatarPositioned({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Positioned(
        top: childSize / 2,
        left: childSize / 4,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: childSize,
            maxWidth: childSize,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 8,
                color: Theme.of(context).colorScheme.surface,
              ),
              shape: BoxShape.circle,
            ),
            position: DecorationPosition.foreground,
            child: child,
          ),
        ),
      );
}
