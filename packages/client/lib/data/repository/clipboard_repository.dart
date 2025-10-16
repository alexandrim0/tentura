import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClipboardRepository {
  const ClipboardRepository();

  Future<String> getStringFromClipboard() async {
    if (await Clipboard.hasStrings()) {
      try {
        return (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
      } catch (_) {}
    }
    return '';
  }
}
