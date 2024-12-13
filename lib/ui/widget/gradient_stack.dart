import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class GradientStack extends StatelessWidget {
  static const defaultHeight = 300.0;

  const GradientStack({
    required this.children,
    this.height = defaultHeight,
    this.borderWidth,
    super.key,
  });

  final double height;
  final double? borderWidth;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          // Gradient
          RepaintBoundary(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              minHeight: 200,
              maxHeight: 200,
              child: MeshGradient(
                options: MeshGradientOptions(blend: 2.5),
                points: [
                  MeshGradientPoint(
                    position: const Offset(0.2, 0.6),
                    color: const Color(0xFFF9A396),
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.4, 0.1),
                    color: const Color(0xFF8829CD),
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.3, 0.9),
                    color: const Color(0xFF8829CD),
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.5, 0.8),
                    color: const Color(0xFFC52AEE),
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.7, 0.1),
                    color: const Color(0xFFC52AEE),
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.9, 0.8),
                    color: const Color(0xFF24F6FE),
                  ),
                ],
              ),
            ),
          ),
          ...children,
        ],
      );
}
