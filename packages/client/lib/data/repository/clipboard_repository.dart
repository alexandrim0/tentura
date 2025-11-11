import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClipboardRepository {
  const ClipboardRepository();

  Future<String> getStringFromClipboard() async =>
      (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
}
