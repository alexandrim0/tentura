import 'package:flutter/material.dart';

class RatingIndicator extends StatelessWidget {
  const RatingIndicator({
    required this.score,
    super.key,
  });

  final double score;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: _RatingPainter(
        activeColor: colorScheme.primary,
        passiveColor: colorScheme.surfaceBright,
        score: score,
      ),
      size: const Size.square(24),
    );
  }
}

class _RatingPainter extends CustomPainter {
  _RatingPainter({
    required this.activeColor,
    required this.passiveColor,
    required this.score,
  });

  final Color activeColor;
  final Color passiveColor;
  final double score;

  @override
  void paint(Canvas canvas, Size size) {
    final activePaint = Paint()
      ..color = activeColor
      ..isAntiAlias = true
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final passivePaint = Paint()
      ..color = passiveColor
      ..isAntiAlias = true
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(
        const Offset(4, 4),
        const Offset(20, 4),
        score > _sector * 2 ? activePaint : passivePaint,
      )
      ..drawLine(
        const Offset(4, 12),
        const Offset(20, 12),
        score > _sector ? activePaint : passivePaint,
      )
      ..drawLine(
        const Offset(4, 20),
        const Offset(20, 20),
        score > 0 ? activePaint : passivePaint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  static const _sector = 100 / 4;
}
