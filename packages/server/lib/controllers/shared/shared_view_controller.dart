import 'package:get_it/get_it.dart';
import 'package:jaspr/server.dart';

import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/comment_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/view/components/shared_view_component.dart';
import 'package:tentura_server/view/styles/shared_view_styles.dart';
import 'package:tentura_server/view/utils/header.dart';
import 'package:tentura_server/view/utils/meta.dart';

Future<Response> sharedViewController(Request request) async {
  final ogId = request.requestedUri.queryParameters['id'];

  late final String ogTitle;
  late final String ogDescription;
  late final String ogImagePath;
  late final Object model;

  switch (ogId?[0]) {
    case 'U':
      final user = await GetIt.I<UserRepository>().getUserById(ogId!);
      model = user;
      ogTitle = user.title;
      ogDescription = user.description;
      ogImagePath = user.imagePath;

    case 'B':
      final beacon = await GetIt.I<BeaconRepository>().getBeaconById(ogId!);
      model = beacon;
      ogTitle = beacon.title;
      ogDescription = beacon.description;
      ogImagePath = beacon.imagePath;

    case 'C':
      final comment = await GetIt.I<CommentRepository>().getCommentById(ogId!);
      model = comment;
      ogTitle = comment.beacon.title;
      ogDescription = comment.content;
      ogImagePath = comment.beacon.imagePath;

    default:
      return Response.badRequest();
  }

  return Response.ok(
    await renderComponent(
      Document(
        title: 'Tentura',
        head: headerLogo,
        meta: {
          ...metaCommon,
          ...buildMetaOpenGraph(
            id: ogId,
            title: ogTitle,
            description: ogDescription,
            imagePath: ogImagePath,
          ),
        },
        body: SharedViewComponent(model: model),
        styles: defaultStyles,
      ),
    ),
    headers: {
      'Content-Type': 'text/html',
    },
  );
}
