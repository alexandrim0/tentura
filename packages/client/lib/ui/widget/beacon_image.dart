import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/beacon.dart';

import 'cached_image/cached_image.dart';

class BeaconImage extends StatelessWidget {
  const BeaconImage({
    required this.beacon,
    this.boxFit = BoxFit.cover,
    super.key,
  });

  final Beacon beacon;

  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    final placeholder = Image.asset(
      'images/placeholder/beacon.jpg',
      // ignore: avoid_redundant_argument_values // set from env
      package: kAssetPackage,
      fit: boxFit,
    );
    return beacon.hasPicture
        ? CachedImage(
            imageUrl: '$kImageServer/$kImagesPath/'
                '${beacon.author.id}/${beacon.id}.$kImageExt',
            placeholder: placeholder,
            boxFit: boxFit,
          )
        : placeholder;
  }
}
