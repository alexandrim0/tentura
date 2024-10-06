export 'package:share_handler/share_handler.dart'
    show ShareHandlerPlatform, SharedMedia;

export 'package:share_handler/share_handler.dart'
    if (dart.library.js_interop) 'src/share_handler_dummy.dart';
