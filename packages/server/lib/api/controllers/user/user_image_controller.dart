import 'dart:developer';
import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/api/helpers/remote_storage_helper.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/domain/exception.dart';

import 'user_controller.dart';

@Injectable(order: 3)
final class UserImageController extends UserController
    with RemoteStorageHelper {
  UserImageController(
    this._remoteStorage,
    this._beaconRepository,
    super.userRepository,
  );

  final BeaconRepository _beaconRepository;

  final Minio _remoteStorage;

  @override
  Future<Response> handler(Request request) async {
    if (request.mimeType != kContentTypeJpeg) {
      return Response.badRequest(body: 'Wrong MIME!');
    }
    final userId = request.userId;
    var eTag = '';

    switch (request.url.queryParameters['id']) {
      case final String id when id.startsWith('U'):
        if (id != userId) {
          return Response.unauthorized(null);
        }
        try {
          eTag = await _remoteStorage.putObject(
            kS3Bucket,
            getUserObjectName(userId: id),
            request.read().map(Uint8List.fromList),
            metadata: _s3metadata,
          );
        } catch (e) {
          return Response.internalServerError(body: e.toString());
        }

      case final String id when id.startsWith('B'):
        try {
          final beacon = await _beaconRepository.getBeaconById(id);
          if (beacon.author.id != userId) {
            return Response.unauthorized(null);
          }
          if (!beacon.hasPicture) {
            return Response.forbidden(null);
          }
          eTag = await _remoteStorage.putObject(
            kS3Bucket,
            getBeaconObjectName(userId: userId, beaconId: id),
            request.read().map(Uint8List.fromList),
            metadata: _s3metadata,
          );
        } on IdNotFoundException catch (e) {
          log(e.toString());
          return Response.notFound(e.toString());
        } catch (e) {
          log(e.toString());
          return Response.internalServerError(body: e.toString());
        }

      default:
        return Response.badRequest(body: 'Wrong ID!');
    }
    return Response.ok(null, headers: {'E-Tag': eTag});
  }

  static const _s3metadata = {
    'x-amz-acl': 'public-read',
    kHeaderContentType: kContentTypeJpeg,
  };
}
