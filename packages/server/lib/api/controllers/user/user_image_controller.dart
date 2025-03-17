import 'dart:developer';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/exception.dart';

@Injectable(order: 3)
final class UserImageController {
  UserImageController(this._imageRepository, this._beaconRepository);

  final BeaconRepository _beaconRepository;

  final ImageRepository _imageRepository;

  Future<Response> handler(Request request) async {
    if (request.mimeType != kContentTypeJpeg) {
      return Response.badRequest(body: 'Wrong MIME!');
    }
    var eTag = '';
    final requestUserId = (request.context[JwtEntity.key]! as JwtEntity).sub;

    switch (request.url.queryParameters['id']) {
      case final String userId when userId.startsWith('U'):
        if (userId != requestUserId) {
          return Response.unauthorized(null);
        }
        try {
          eTag = await _imageRepository.putUserImage(
            userId: userId,
            bytes: request.read().map(Uint8List.fromList),
          );
        } catch (e) {
          return Response.internalServerError(body: e.toString());
        }

      case final String beaconId when beaconId.startsWith('B'):
        try {
          final beacon = await _beaconRepository.getBeaconById(
            beaconId: beaconId,
          );
          if (beacon.author.id != requestUserId) {
            return Response.unauthorized(null);
          }
          if (!beacon.hasPicture) {
            return Response.forbidden(null);
          }
          eTag = await _imageRepository.putBeaconImage(
            authorId: requestUserId,
            beaconId: beaconId,
            bytes: request.read().map(Uint8List.fromList),
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
}
