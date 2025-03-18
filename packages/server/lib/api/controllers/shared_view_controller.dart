import 'package:injectable/injectable.dart';
import 'package:jaspr/server.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/comment_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/api/view/shared_view/shared_view_document.dart';

import '_base_controller.dart';

@Injectable(order: 3)
final class SharedViewController extends BaseController {
  const SharedViewController(super.env);

  @override
  Future<Response> handler(Request request) async {
    final ogId = request.requestedUri.queryParameters['id'];
    try {
      return Response.ok(
        await renderComponent(
          SharedViewDocument(
            entity: switch (ogId?[0]) {
              'U' => await getIt<UserRepository>().getUserById(ogId!),
              'B' => await getIt<BeaconRepository>().getBeaconById(
                beaconId: ogId!,
              ),
              'C' => await getIt<CommentRepository>().getCommentById(ogId!),
              _ => throw IdWrongException(id: ogId!),
            },
          ),
        ),
        headers: {kHeaderContentType: kContentTypeHtml},
      );
    } on IdWrongException catch (e) {
      return Response.badRequest(body: e.toString());
    } on IdNotFoundException catch (e) {
      return Response.badRequest(body: e.toString());
    } catch (e) {
      return Response.internalServerError();
    }
  }
}
