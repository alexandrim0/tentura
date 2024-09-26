export 'package:ferry/ferry.dart' show DataSource, OperationResponse;

export 'src/exception.dart';
export 'src/tentura_api_native.dart'
    if (dart.library.js_interop) 'src/tentura_api_web.dart';
