import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/consts.dart';

@singleton
class RemoteStorage {
  final _remoteStorage = Minio(
    accessKey: kS3AccessKey,
    secretKey: kS3SecretKey,
    endPoint: kS3Endpoint,
    pathStyle: false,
  );

  Future<Uint8List> getObject(String path) async {
    final stream = await _remoteStorage.getObject(kS3Bucket, path);
    final buffer = await stream.cast<Uint8List>().fold(
      BytesBuilder(copy: false),
      (p, e) => p..add(e),
    );
    return buffer.takeBytes();
  }

  Future<String> putObject(String path, Stream<Uint8List> bytes) =>
      _remoteStorage.putObject(kS3Bucket, path, bytes, metadata: _s3metadata);

  Future<void> removeObject(String path) =>
      _remoteStorage.removeObject(kS3Bucket, path);

  static const _s3metadata = {
    'x-amz-acl': 'public-read',
    kHeaderContentType: kContentTypeJpeg,
  };
}
