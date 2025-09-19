import 'dart:async';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:share_handler/share_handler.dart'
    if (dart.library.js_interop) 'share_handler_dummy.dart';

@lazySingleton
class ShareHandlerService {
  ShareHandlerService(this._logger) {
    if (!kIsWeb) {
      _subscription = ShareHandler.instance.sharedMediaStream.listen(_handler);
      unawaited(ShareHandler.instance.getInitialSharedMedia().then(_handler));
    }
  }

  final Logger _logger;

  late final StreamSubscription<SharedMedia> _subscription;

  @disposeMethod
  Future<void> dispose() => kIsWeb ? Future.value() : _subscription.cancel();

  void _handler(SharedMedia? e) {
    if (e == null) return;

    _logger.d('String: ${e.content}');

    if (e.attachments != null) {
      for (final e in e.attachments!) {
        _logger.d('Attached: ${e?.path}');
      }
    }
  }
}
