import 'dart:typed_data';

mixin BinaryBodyReader {
  Future<Uint8List> readBodyAsBytes(
      Stream<List<int>> Function() getStream) async {
    final builder = BytesBuilder(
      copy: false,
    );
    await for (final part in getStream()) {
      builder.add(part);
    }
    return builder.takeBytes();
  }
}
