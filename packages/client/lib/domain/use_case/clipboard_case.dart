import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';

@injectable
class ClipboardCase {
  const ClipboardCase();

  Future<String> getCodeFromClipboard({String prefix = ''}) async {
    final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    if (text == null) {
      return '';
    } else if (text.length == kIdLength && text.startsWith(prefix)) {
      return text;
    }

    try {
      final id = Uri.dataFromString(text).queryParameters['id'];
      if (id != null && text.length == kIdLength && text.startsWith(prefix)) {
        return id;
      }
    } catch (_) {}

    return '';
  }
}
