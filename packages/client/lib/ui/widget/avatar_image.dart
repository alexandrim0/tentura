import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    required this.size,
    required this.profile,
    this.boxFit = BoxFit.cover,
    super.key,
  });

  const AvatarImage.small({
    required this.profile,
    super.key,
  })  : boxFit = BoxFit.cover,
        size = 40;

  final Profile profile;
  final BoxFit boxFit;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: profile.hasAvatar
            ? BlurHash(
                hash: profile.blurhash,
                image: _getAvatarUrl(profile.id),
                imageFit: boxFit,
              )
            : Image.asset(
                'images/placeholder/avatar.jpg',
                // ignore: avoid_redundant_argument_values // set from env
                package: kAssetPackage,
                height: size,
                width: size,
                fit: boxFit,
              ),
      ),
    );
  }

  static String _getAvatarUrl(String userId) =>
      '$kImageServer/$kImagesPath/$userId/avatar.$kImageExt';
}
