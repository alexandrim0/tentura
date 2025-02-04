import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/api/helpers/binary_body_reader.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/domain/exception.dart';

import 'user_controller.dart';

@Injectable(
  order: 3,
)
final class UserImageUploadController extends UserController
    with BinaryBodyReader {
  UserImageUploadController(
    this._beaconRepository,
    super.userRepository,
  );

  final BeaconRepository _beaconRepository;

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
          await userRepository.setUserImage(
            id: userId,
            imageBytes: await readBodyAsBytes(request.read),
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
          await _beaconRepository.setBeaconImage(
            beacon: beacon,
            imageBytes: await readBodyAsBytes(request.read),
          );
        } on IdNotFoundException catch (e) {
          return Response.notFound(
            e.toString(),
          );
        } catch (e) {
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
