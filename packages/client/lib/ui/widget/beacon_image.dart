import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/beacon.dart';

class BeaconImage extends StatelessWidget {
  const BeaconImage({
    required this.beacon,
    this.boxFit = BoxFit.cover,
    super.key,
  });

  final Beacon beacon;

  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) => beacon.blurhash.isNotEmpty
      ? AspectRatio(
          aspectRatio: beacon.imageHeight > 0
              ? beacon.imageWidth / beacon.imageHeight
              : 1,
          child: BlurHash(
            image: '$kImageServer/$kImagesPath/'
                '${beacon.author.id}/${beacon.id}.$kImageExt',
            hash: beacon.blurhash,
            imageFit: boxFit,
          ),
        )
      : Image.asset(
          kAssetBeaconPlaceholder,
          // ignore: avoid_redundant_argument_values // set from env
          package: kAssetPackage,
          fit: boxFit,
        );
}
