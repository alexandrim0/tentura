import 'package:injectable/injectable.dart';
import 'package:jaspr/server.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/comment_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/api/view/shared_view/shared_view_document.dart';
import 'package:tentura_server/domain/use_case/opinion_case.dart';

import '_base_controller.dart';

@Injectable(order: 3)
final class SharedViewController extends BaseController {
  const SharedViewController(super.env);

  @override
  Future<Response> handler(Request request) async {
    if (!kRenderSharedPreview &&
        (request.headers['User-Agent']?.contains('Mozilla') ?? false)) {
      return Response.found(
        Uri(
          scheme: request.requestedUri.scheme,
          host: request.requestedUri.host,
          port: request.requestedUri.port,
          path: '/',
          fragment:
              '${request.requestedUri.path}?${request.requestedUri.query}',
        ),
      );
    }

    try {
      final ogId =
          request.requestedUri.queryParameters['id'] ??
          (throw const IdWrongException());
      final html = await renderComponent(
        SharedViewDocument(
          entity: switch (ogId[0]) {
            'B' => await getIt<BeaconRepository>().getBeaconById(
              beaconId: ogId,
            ),
            'C' => await getIt<CommentRepository>().getCommentById(ogId),
            // TBD: Invitation preview
            'I' => throw UnimplementedError(),
            'O' => await getIt<OpinionCase>().getOpinionById(ogId),
            'U' => await getIt<UserRepository>().getById(ogId),
            _ => throw IdWrongException(id: ogId),
          },
        ),
      );
      return Response(html.statusCode, body: html.body, headers: html.headers);
    } on IdWrongException catch (e) {
      return Response.badRequest(body: e.toString());
    } on IdNotFoundException catch (e) {
      return Response.badRequest(body: e.toString());
    } catch (e) {
      return Response.internalServerError();
    }
  }
}
