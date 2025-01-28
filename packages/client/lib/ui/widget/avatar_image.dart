import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:tentura/consts.dart';

import 'cached_image/cached_image.dart';

class AvatarImage extends StatelessWidget {
  static Future<void> evictFromCache(String id) =>
      kIsWeb ? Future.value() : CachedImage.evictFromCache(_getAvatarUrl(id));

  const AvatarImage({
    required this.size,
    required this.userId,
    this.boxFit = BoxFit.cover,
    super.key,
  });

  const AvatarImage.small({
    required this.userId,
    super.key,
  })  : boxFit = BoxFit.cover,
        size = 40;

  final String userId;
  final BoxFit boxFit;
  final double size;

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: userId.isEmpty
          ? placeholder
          : CachedImage(
              width: size,
              height: size,
              boxFit: boxFit,
              placeholder: placeholder,
              imageUrl: _getAvatarUrl(userId),
            ),
    );
  }

  static String _getAvatarUrl(String userId) =>
      '$kImageServer/$kImagesPath/$userId/avatar.jpg';
}
