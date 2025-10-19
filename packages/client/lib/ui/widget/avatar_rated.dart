import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:blurhash_shader/blurhash_shader.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';

import 'tentura_icons.dart';

class AvatarRated extends StatelessWidget {
  static const sizeBig = 160.0;

  static const sizeSmall = sizeBig / 4;

  // TBD: remove assets
  static Widget getAvatarPlaceholder({
    int? cacheHeight,
    int? cacheWidth,
    BoxFit? fit,
  }) => Image.asset(
    'images/placeholder/avatar.jpg',
    // ignore: avoid_redundant_argument_values //
    package: kAssetPackage,
    cacheHeight: cacheHeight,
    cacheWidth: cacheWidth,
    fit: fit,
  );

  AvatarRated({
    required this.profile,
    this.withRating = true,
    this.boxFit = BoxFit.cover,
    this.size = sizeSmall,
    super.key,
  });

  AvatarRated.big({
    required this.profile,
    this.withRating = true,
    super.key,
  }) : boxFit = BoxFit.cover,
       size = sizeBig;

  AvatarRated.small({
    required this.profile,
    this.withRating = true,
    super.key,
  }) : boxFit = BoxFit.cover,
       size = sizeSmall;

  final double size;

  final BoxFit boxFit;

  final Profile profile;

  final bool withRating;

  late final _cacheSize = size.ceil();

  late final _avatar = ClipOval(
    child: profile.hasNoAvatar
        ? getAvatarPlaceholder(
            cacheHeight: _cacheSize,
            cacheWidth: _cacheSize,
            fit: boxFit,
          )
        : profile.image?.blurHash.isEmpty ?? true
        ? _imageNetwork
        : BlurHash(
            profile.image!.blurHash,
            child: _imageNetwork,
          ),
  );

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: withRating
        ? CustomPaint(
            painter: _RatingPainter(
              color: Theme.of(context).colorScheme.primary,
              isSeeingMe: profile.isSeeingMe,
              score: profile.score,
            ),
            child: Padding(
              padding: EdgeInsets.all(size / 8),
              child: _avatar,
            ),
          )
        : _avatar,
  );

  Widget get _imageNetwork => Image.network(
    profile.avatarUrl,
    errorBuilder: (_, _, _) => getAvatarPlaceholder(
      cacheHeight: _cacheSize,
      cacheWidth: _cacheSize,
      fit: boxFit,
    ),
    cacheHeight: _cacheSize,
    cacheWidth: _cacheSize,
    fit: boxFit,
  );
}

class _RatingPainter extends CustomPainter {
  _RatingPainter({
    required this.color,
    required this.score,
    required this.isSeeingMe,
  });

  final Color color;
  final double score;
  final bool? isSeeingMe;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = size.height / 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Rating arcs
    for (var i = 0; i < 3; i++) {
      if (score > kRatingSector * (i + 1)) {
        canvas.drawArc(
          rect,
          _degreeToRadians(90 + 67.5 * i),
          _degreeToRadians(45),
          false,
          paint,
        );
      } else {
        break;
      }
    }

    // An eye
    if (isSeeingMe != null) {
      final eyeIcon = isSeeingMe!
          ? TenturaIcons.eyeOpen
          : TenturaIcons.eyeClosed;
      final builder =
          ui.ParagraphBuilder(
              ui.ParagraphStyle(
                fontFamily: eyeIcon.fontFamily,
                textAlign: TextAlign.right,
                fontSize: size.height / 2,
                maxLines: 1,
              ),
            )
            ..pushStyle(ui.TextStyle(color: color))
            ..addText(String.fromCharCode(eyeIcon.codePoint));
      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: size.width));
      canvas.drawParagraph(
        paragraph,
        Offset(size.height / 8, size.width / 1.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  static double _degreeToRadians(double degree) => (pi / 180) * degree;
}
