import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import 'package:tentura/domain/exception/generic_exception.dart';

@injectable
class PlatformRepository {
  const PlatformRepository({
    required Logger log,
  }) : _log = log;

  final Logger _log;

  Future<String> getStringFromClipboard() async =>
      (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';

  Future<void> launchUrl(String uri) => url.launchUrl(Uri.parse(uri));

  Future<void> launchUri(Uri uri) async {
    try {
      await url.launchUrl(uri);
    } catch (e) {
      _log.e(e);
      throw const UnknownPlatformException();
    }
  }
}
