import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:share_handler/share_handler.dart'
    if (dart.library.js_interop) 'share_handler_dummy.dart';

@lazySingleton
class ShareHandlerService {
  ShareHandlerService() {
    if (!kIsWeb) {
      _subscription = ShareHandler.instance.sharedMediaStream.listen(_handler);
      ShareHandler.instance.getInitialSharedMedia().then(_handler);
    }
  }

  late final StreamSubscription<SharedMedia> _subscription;

  @disposeMethod
  Future<void> dispose() => kIsWeb ? Future.value() : _subscription.cancel();

  void _handler(SharedMedia? e) {
    if (e == null) return;
    if (kDebugMode) {
      print('String: ${e.content}');
      if (e.attachments == null) return;
      for (final e in e.attachments!) {
        print('Attached: ${e?.path}');
      }
    }
  }
}
