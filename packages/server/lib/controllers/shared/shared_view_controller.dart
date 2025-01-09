import 'package:get_it/get_it.dart';
import 'package:jaspr/server.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/comment_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/view/components/shared_view_component.dart';

Future<Response> sharedViewController(Request request) async {
  final ogId = request.requestedUri.queryParameters['id'];
  try {
    return Response.ok(
      await renderComponent(
        SharedViewComponent(
          entity: switch (ogId?[0]) {
            'U' => await GetIt.I<UserRepository>().getUserById(ogId!),
            'B' => await GetIt.I<BeaconRepository>().getBeaconById(ogId!),
            'C' => await GetIt.I<CommentRepository>().getCommentById(ogId!),
            _ => throw WrongIdException(ogId),
          },
        ),
      ),
      headers: {
        kHeaderContentType: kContentTypeHtml,
      },
    );
  } on WrongIdException catch (e) {
    return Response.badRequest(
      body: e.toString(),
    );
  } on IdNotFoundException catch (e) {
    return Response.badRequest(
      body: e.toString(),
    );
  } catch (e) {
    return Response.internalServerError();
  }
}
