import 'package:share_handler/share_handler.dart' show ShareHandlerPlatform;

class ShareHandler {
  static ShareHandlerPlatform get instance =>
      throw UnsupportedError('Do not use in browser!');
}
