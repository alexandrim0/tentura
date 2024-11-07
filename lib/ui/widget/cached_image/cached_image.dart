import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart'
    if (dart.library.js_interop) 'cached_image_web.dart';

class CachedImage extends StatelessWidget {
  static Future<void> evictFromCache(String url) =>
      kIsWeb ? Future.value() : CachedNetworkImage.evictFromCache(url);

  const CachedImage({
    required this.imageUrl,
    required this.placeholder,
    this.filterQuality = FilterQuality.high,
    this.boxFit = BoxFit.cover,
    this.height,
    this.width,
    super.key,
  });

  final String imageUrl;
  final Image placeholder;
  final FilterQuality filterQuality;
  final double? height;
  final double? width;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) => kIsWeb
      ? Image.network(
          imageUrl,
          fit: boxFit,
          width: width,
          height: height,
          filterQuality: filterQuality,
          errorBuilder: (context, url, error) {
            if (kDebugMode) print(error);
            return placeholder;
          },
        )
      : CachedNetworkImage(
          fit: boxFit,
          width: width,
          height: height,
          imageUrl: imageUrl,
          filterQuality: filterQuality,
          placeholder: (context, url) => placeholder,
          errorWidget: (context, url, error) => placeholder,
        );
}
