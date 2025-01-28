import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'cached_image/cached_image.dart';

class AvatarRated extends StatelessWidget {
  static String? assetPackage;

  static Future<void> evictFromCache(String id) =>
      kIsWeb ? Future.value() : CachedImage.evictFromCache(_getAvatarUrl(id));

  const AvatarRated({
    required this.profile,
    this.boxFit = BoxFit.cover,
    this.size = 40,
    super.key,
  });

  final double size;

  final BoxFit boxFit;

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final placeholder = Image.asset(
      'images/placeholder/avatar.jpg',
      // ignore: avoid_redundant_argument_values // set from env
      package: kAssetPackage,
      height: size,
      width: size,
      fit: boxFit,
    );
    final avatar = Padding(
      padding: kPaddingAllS,
      child: ClipOval(
        child: profile.hasAvatar
            ? CachedImage(
                imageUrl: _getAvatarUrl(profile.id),
                placeholder: placeholder,
                height: size,
                width: size,
              )
            : placeholder,
      ),
    );
    return profile.score < kRatingSector
        ? avatar
        : CustomPaint(
            painter: _RatingPainter(
              color: Theme.of(context).colorScheme.primary,
              score: profile.score,
            ),
            child: avatar,
          );
  }

  static String _getAvatarUrl(String userId) =>
      '$kImageServer/$kImagesPath/$userId/avatar.jpg';
}

class _RatingPainter extends CustomPainter {
  _RatingPainter({
    required this.score,
    required this.color,
  });

  final Color color;
  final double score;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // first arc
    canvas.drawArc(
      rect,
      _degreeToRadians(90),
      _degreeToRadians(45),
      false,
      paint,
    );

    if (score > kRatingSector * 2) {
      // second arc
      canvas.drawArc(
        rect,
        _degreeToRadians(157.5),
        _degreeToRadians(45),
        false,
        paint,
      );
    }
    if (score > kRatingSector * 3) {
      // third arc
      canvas.drawArc(
        rect,
        _degreeToRadians(225),
        _degreeToRadians(45),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  static double _degreeToRadians(double degree) => (pi / 180) * degree;
}
