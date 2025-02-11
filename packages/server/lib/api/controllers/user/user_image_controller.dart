import 'dart:io';
import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/api/helpers/binary_body_reader.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/service/image_service.dart';
import 'package:tentura_server/domain/exception.dart';

import 'user_controller.dart';

@Injectable(
  order: 3,
)
final class UserImageController extends UserController with BinaryBodyReader {
  UserImageController(
    this._beaconRepository,
    super.userRepository,
  );

  final BeaconRepository _beaconRepository;

  final _imageService = const ImageService();

  @override
  Future<Response> handler(Request request) async {
    if (request.mimeType != kContentTypeJpeg) {
      return Response.badRequest(
        body: 'Wrong MIME!',
      );
    }
    final userId = request.userId;

    switch (request.url.queryParameters['id']) {
      case final String id when id.startsWith('U'):
        if (id != userId) {
          return Response.unauthorized(null);
        }
        try {
          await _imageService.saveStreamToFile(
            request.read(),
            File('$kImageFolderPath/$id/avatar.$kImageExt'),
          );
        } catch (e) {
          return Response.internalServerError(
            body: e.toString(),
          );
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
          await _imageService.saveStreamToFile(
            request.read(),
            File('$kImageFolderPath/$userId/$id.$kImageExt'),
          );
        } on IdNotFoundException catch (e) {
          log(e.toString());
          return Response.notFound(
            e.toString(),
          );
        } catch (e) {
          log(e.toString());
          return Response.internalServerError(
            body: e.toString(),
          );
        }

      default:
        return Response.badRequest(
          body: 'Wrong ID!',
        );
    }
    return Response.ok(null);
  }
}
