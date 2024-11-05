// ignore_for_file: avoid_unused_constructor_parameters

import 'package:flutter/material.dart';
import 'package:nil/nil.dart';

class CachedNetworkImage extends Nil {
  static Future<void> evictFromCache(String url) => Future.value();

  const CachedNetworkImage({
    BoxFit? fit,
    double? width,
    double? height,
    String? imageUrl,
    FilterQuality? filterQuality,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, Object)? errorWidget,
    super.key,
  });
}
