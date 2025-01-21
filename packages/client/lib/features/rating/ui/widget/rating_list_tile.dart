import 'dart:math';
import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';

import '../bloc/rating_cubit.dart';

class RatingListTile extends StatelessWidget {
  RatingListTile({
    required this.profile,
    required this.isDarkMode,
    this.height = 40,
    this.ratio = 2.5,
    super.key,
  });

  final bool isDarkMode;
  final double ratio;
  final double height;
  final Profile profile;

  late final _barbellSize = Size(height * ratio, height);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => context.read<RatingCubit>().navigateTo(
              '$kPathProfileView?id=${profile.id}',
            ),
        child: Row(
          children: [
            AvatarRated(
              profile: profile,
              size: height,
            ),
            Padding(
              padding: kPaddingH,
              child: Text(profile.title),
            ),
            const Spacer(),
            CustomPaint(
              size: _barbellSize,
              painter: _CustomBarbellPainter(
                profile.score,
                profile.rScore,
                isDarkMode,
              ),
            ),
          ],
        ),
      );
}

class _CustomBarbellPainter extends CustomPainter {
  const _CustomBarbellPainter(
    this.leftWeight,
    this.rightWeight,
    this.isDarkTheme,
  );

  final bool isDarkTheme;
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

  double _calcRadius(
    double minRadius,
    double maxRadius,
    double weight,
  ) =>
      min(
        maxRadius,
        (maxRadius - minRadius) * weight + minRadius,
      );

  Color _calcColor(double weight) {
    var index = 50;
    if (weight > 0.75) {
      index = 900;
    } else if (weight > 0.5) {
      index = 700;
    } else if (weight > 0.25) {
      index = 500;
    } else if (weight > 0) {
      index = 300;
    }
    return isDarkTheme ? Colors.amber[index]! : Colors.deepPurple[index]!;
  }
}
