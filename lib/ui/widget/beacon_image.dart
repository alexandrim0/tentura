import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:tentura/consts.dart';

class BeaconImage extends StatelessWidget {
  static String getBeaconUrl({
    required String userId,
    required String beaconId,
    String serverName = kAppLinkBase,
  }) =>
      'https://$serverName/images/$userId/$beaconId.jpg';

  const BeaconImage({
    required this.authorId,
    this.beaconId = '',
    this.boxFit = BoxFit.cover,
    this.serverName = kAppLinkBase,
    this.height,
    this.width,
    super.key,
  });

  final String serverName;
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
        : CachedNetworkImage(
            height: height,
            width: width,
            filterQuality: FilterQuality.high,
            placeholder: (context, url) => placeholder,
            errorWidget: (context, url, error) => placeholder,
            imageUrl: getBeaconUrl(
              serverName: serverName,
              userId: authorId,
              beaconId: beaconId,
            ),
          );
  }
}
