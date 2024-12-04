import 'package:flutter/material.dart';

class GradientStack extends StatelessWidget {
  static const defaultHeight = 300.0;

  static const _gradientLight = LinearGradient(
    colors: [
      Color(0xFFF9A396),
      Color(0xFFC52AEE),
      Color(0xFF8829CD),
      Color(0xFF24F6FE),
      Color(0xFF24F6FE),
    ],
    stops: [
      0.1,
      0.3,
      0.5,
      0.7,
      0.8,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.mirror,
    transform: GradientRotation(0.3),
  );
  static const _gradientDark = LinearGradient(
    colors: [
      Color(0x77F9A396),
      Color(0x77C52AEE),
      Color(0x778829CD),
      Color(0x7724F6FE),
      Color(0x7724F6FE),
    ],
    stops: [
      0.1,
      0.3,
      0.5,
      0.7,
      0.8,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.mirror,
    transform: GradientRotation(0.3),
  );

  final double height;
  final double? borderWidth;
  final List<Widget> children;

  const GradientStack({
    required this.children,
    this.height = defaultHeight,
    this.borderWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          // Gradient
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                    width: borderWidth ?? height / 3,
                  ),
                ),
                gradient: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? _gradientLight
                    : _gradientDark,
              ),
            ),
          ),
          ...children,
        ],
      );
}
