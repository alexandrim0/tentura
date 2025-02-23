import 'dart:math';
import 'package:flutter/material.dart';
import 'package:blurhash_shader/blurhash_shader.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';

class AvatarRated extends StatelessWidget {
  static const sizeBig = 160.0;

  static const sizeSmall = sizeBig / 4;

  AvatarRated({
    required this.profile,
    this.withRating = true,
    this.boxFit = BoxFit.cover,
    this.size = sizeSmall,
    super.key,
  });

  AvatarRated.big({required this.profile, this.withRating = true, super.key})
    : boxFit = BoxFit.cover,
      size = sizeBig;

  AvatarRated.small({required this.profile, this.withRating = true, super.key})
    : boxFit = BoxFit.cover,
      size = sizeSmall;

  final double size;

  final BoxFit boxFit;

  final Profile profile;

  final bool withRating;

  late final _cacheSize = size.ceil();

  late final _avatar = ClipOval(
    child:
        profile.hasNoAvatar
            ? _placeholder
            : profile.blurhash.isEmpty
            ? _imageNetwork
            : BlurHash(profile.blurhash, child: _imageNetwork),
  );

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child:
        withRating && profile.score >= kRatingSector
            ? CustomPaint(
              painter: _RatingPainter(
                color: Theme.of(context).colorScheme.primary,
                score: profile.score,
              ),
              child: Padding(padding: const EdgeInsets.all(5), child: _avatar),
            )
            : _avatar,
  );

  Widget get _imageNetwork => Image.network(
    profile.avatarUrl,
    errorBuilder: (_, _, _) => _placeholder,
    cacheHeight: _cacheSize,
    cacheWidth: _cacheSize,
    fit: boxFit,
  );

  Widget get _placeholder => Image.asset(
    kAssetAvatarPlaceholder,
    // ignore: avoid_redundant_argument_values // set from env
    package: kAssetPackage,
    cacheHeight: _cacheSize,
    cacheWidth: _cacheSize,
    fit: boxFit,
  );
}

class _RatingPainter extends CustomPainter {
  _RatingPainter({required this.score, required this.color});

  final Color color;
  final double score;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint =
        Paint()
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
