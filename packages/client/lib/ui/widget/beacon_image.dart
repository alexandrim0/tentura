import 'package:flutter/material.dart';
import 'package:blurhash_shader/blurhash_shader.dart';

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
  Widget build(BuildContext context) =>
      beacon.hasNoPicture
          ? _placeholder
          : beacon.blurhash.isEmpty
          ? _imageNetwork
          : AspectRatio(
            aspectRatio:
                beacon.imageHeight > 0
                    ? beacon.imageWidth / beacon.imageHeight
                    : 1,
            child: BlurHash(beacon.blurhash, child: _imageNetwork),
          );

  Widget get _imageNetwork => Image.network(
    beacon.imageUrl,
    fit: boxFit,
    errorBuilder: (_, _, _) => _placeholder,
  );

  Widget get _placeholder => Image.asset(
    kAssetBeaconPlaceholder,
    // ignore: avoid_redundant_argument_values // set from env
    package: kAssetPackage,
    fit: boxFit,
  );
}
