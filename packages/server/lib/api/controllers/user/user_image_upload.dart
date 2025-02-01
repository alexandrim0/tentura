import 'dart:io';
import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';

import 'user_controller.dart';

@Injectable(
  order: 3,
)
final class UserImageUploadController extends UserController {
  UserImageUploadController(
    super.userRepository,
  );

  @override
  Future<Response> handler(Request request) async {
    if (request.mimeType != kContentTypeJpeg) {
      return Response.badRequest(
        body: 'Wrong MIME!',
      );
    }
    final fileName = switch (request.url.queryParameters['id']) {
      final String id when id.startsWith('U') => 'avatar',
      final String id when id.startsWith('B') => id,
      _ => '',
    };
    if (fileName.isEmpty) {
      return Response.badRequest(
        body: 'Wrong ID!',
      );
    }
    final file = File(
      '$kImageFolderPath/${request.userId}/$fileName.jpg',
    );
    if (file.existsSync()) {
      return Response.badRequest(
        body: 'File already exists!',
      );
    }
    file.parent.createSync(
      recursive: true,
    );
    final sink = file.openWrite();
    try {
      await sink.addStream(request.read());
      await sink.flush();
    } catch (e) {
      log(e.toString());
      return Response.internalServerError();
    } finally {
      await sink.close();
    }
    return Response.ok(null);
  }
}
