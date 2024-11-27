import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';

import 'cached_image/cached_image.dart';

class BeaconImage extends StatelessWidget {
  const BeaconImage({
    required this.authorId,
    this.beaconId = '',
    this.boxFit = BoxFit.cover,
    this.height,
    this.width,
    super.key,
  });

  final String beaconId;
  final String authorId;
  final double? height;
  final double? width;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    final placeholder = Image.asset(
      'assets/images/image-placeholder.jpg',
      height: height,
      width: width,
      fit: boxFit,
    );
    return beaconId.isEmpty || authorId.isEmpty
        ? placeholder
        : CachedImage(
            imageUrl: '$kAppLinkBase/images/$authorId/$beaconId.jpg',
            placeholder: placeholder,
            boxFit: boxFit,
            height: height,
            width: width,
          );
  }
}
