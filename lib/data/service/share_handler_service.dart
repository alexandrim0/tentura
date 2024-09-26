import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:share_handler_multi/share_handler_multi.dart';

@singleton
class ShareHandlerService {
  ShareHandlerService() {
    if (kIsWeb) {
      _subscription = null;
    } else {
      _subscription = ShareHandler.instance.sharedMediaStream.listen(_handler);
      ShareHandler.instance.getInitialSharedMedia().then(_handler);
    }
  }

  late final StreamSubscription<SharedMedia>? _subscription;

  @disposeMethod
  Future<void> dispose() async => _subscription?.cancel();

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
