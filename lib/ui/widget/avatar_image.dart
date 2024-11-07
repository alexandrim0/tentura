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

  final String userId;
  final BoxFit boxFit;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = Image.asset(
      'assets/images/avatar-placeholder.jpg',
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
      '$kApiUri/images/$userId/avatar.jpg';
}
