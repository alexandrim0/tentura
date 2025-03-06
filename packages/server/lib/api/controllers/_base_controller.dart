import 'dart:typed_data';
import 'package:shelf_plus/shelf_plus.dart';

export 'package:shelf_plus/shelf_plus.dart';

abstract base class BaseController {
  const BaseController();

  Future<Uint8List> readBodyAsBytes(
    Stream<List<int>> Function() getStream,
  ) async {
    final builder = BytesBuilder(copy: false);
    await for (final part in getStream()) {
      builder.add(part);
    }
    return builder.takeBytes();
  }

  Future<Response> handler(Request request);
}
