import 'dart:math';
import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/widget/avatar_image.dart';

class RatingListTile extends StatelessWidget {
  RatingListTile({
    required this.profile,
    this.height = 40,
    this.ratio = 2.5,
    super.key,
  });

  final double ratio;
  final double height;
  final Profile profile;

  late final _barbellSize = Size(height * ratio, height);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => context.pushRoute(
          ProfileViewRoute(id: profile.id),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: AvatarImage(
                userId: profile.imageId,
                size: height,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(profile.title),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: CustomPaint(
                size: _barbellSize,
                painter: _CustomBarbellPainter(
                  profile.score,
                  profile.rScore,
                ),
              ),
            ),
          ],
        ),
      );
}

class _CustomBarbellPainter extends CustomPainter {
  const _CustomBarbellPainter(this.leftWeight, this.rightWeight);

  final double leftWeight;
  final double rightWeight;

  @override
  void paint(Canvas canvas, Size size) {
    final halfHeight = size.height / 2;
    final quarterHeight = halfHeight / 2;
    final leftOffset = Offset(halfHeight, halfHeight);
    final rightOffset = Offset(size.width - halfHeight, halfHeight);
    final maxRadius = halfHeight;
    final minRadius = quarterHeight / 2;
    final leftColor = _calcColor(leftWeight);
    final rightColor = _calcColor(rightWeight);
    canvas
      ..drawLine(
        leftOffset,
        rightOffset,
        Paint()
          ..strokeWidth = quarterHeight / 2
          ..shader = LinearGradient(
            colors: [leftColor, rightColor],
          ).createShader(Rect.fromPoints(leftOffset, rightOffset)),
      )
      ..drawCircle(
        leftOffset,
        _calcRadius(minRadius, maxRadius, leftWeight),
        Paint()..color = leftColor,
      )
      ..drawCircle(
        rightOffset,
        _calcRadius(minRadius, maxRadius, rightWeight),
        Paint()..color = rightColor,
      );
  }

  @override
  bool shouldRepaint(_CustomBarbellPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_CustomBarbellPainter oldDelegate) => false;

  // TBD: normalization
  double _calcRadius(
    double minRadius,
    double maxRadius,
    double weight,
  ) =>
      min(
        maxRadius,
        (maxRadius - minRadius) * weight + minRadius,
      );

  // TBD: normalization
  Color _calcColor(double weight) => weight >= 0.9
      ? Colors.amber[900]!
      : weight < 0.1
          ? Colors.amber[50]!
          : Colors.amber[weight ~/ 0.1 * 100]!;
}
