import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  static Future<void> evictFromCache(String url) => Future.value();

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
  Widget build(BuildContext context) => Image.network(
        imageUrl,
        fit: boxFit,
        width: width,
        height: height,
        filterQuality: filterQuality,
        errorBuilder: (context, url, error) => placeholder,
      );
}
