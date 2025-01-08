import 'package:get_it/get_it.dart';
import 'package:jaspr/server.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/comment_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/view/components/shared_view_component.dart';
import 'package:tentura_server/view/styles/shared_view_styles.dart';

Future<Response> sharedViewController(Request request) async {
  final ogId = request.requestedUri.queryParameters['id'];
  late final Map<String, String> headerMeta;
  late final Component responseBody;

  try {
    switch (ogId?[0]) {
      case 'U':
        final user = await GetIt.I<UserRepository>().getUserById(ogId!);
        responseBody = SharedViewComponent(entity: user);
        headerMeta = _buildMeta(
          id: ogId,
          title: user.title,
          description: user.description,
          imagePath: user.imageUrl,
        );

      case 'B':
        final beacon = await GetIt.I<BeaconRepository>().getBeaconById(ogId!);
        responseBody = SharedViewComponent(entity: beacon);
        headerMeta = _buildMeta(
          id: ogId,
          title: beacon.title,
          description: beacon.description,
          imagePath: beacon.imageUrl,
        );

      case 'C':
        final comment =
            await GetIt.I<CommentRepository>().getCommentById(ogId!);
        responseBody = SharedViewComponent(entity: comment);
        headerMeta = _buildMeta(
          id: ogId,
          title: comment.beacon.title,
          description: comment.content,
          imagePath: comment.beacon.imageUrl,
        );

      default:
        return Response.badRequest(
          body: 'Wrong id [$ogId]',
        );
    }
  } on IdNotFoundException catch (e) {
    return Response.badRequest(
      body: 'Id [${e.message}] not found!',
    );
  } catch (e) {
    return Response.internalServerError();
  }

  return Response.ok(
    await renderComponent(
      Document(
        title: 'Tentura',
        head: _headerLogo,
        meta: headerMeta,
        body: responseBody,
        styles: defaultStyles,
      ),
    ),
    headers: {
      'Content-Type': 'text/html',
    },
  );
}

final _headerLogo = [
  link(
    href: '/static/logo/web_24dp.png',
    rel: 'shortcut icon',
  ),
  link(
    href: '/static/logo/web_32dp.png',
    rel: 'shortcut icon',
  ),
  link(
    href: '/static/logo/web_36dp.png',
    rel: 'shortcut icon',
  ),
  link(
    href: '/static/logo/web_48dp.png',
    rel: 'shortcut icon',
  ),
  link(
    href: '/static/logo/web_64dp.png',
    rel: 'shortcut icon',
  ),
  link(
    href: '/static/logo/web_96dp.png',
    rel: 'shortcut icon',
  ),
  link(
    href: '/static/logo/web_512dp.png',
    rel: 'shortcut icon',
  ),
];

Map<String, String> _buildMeta({
  required String id,
  required String title,
  required String description,
  required String imagePath,
}) =>
    {
      'viewport': 'width=device-width, initial-scale=1, '
          'minimum-scale=1,maximum-scale=1 user-scalable=no',
      'referrer': 'origin-when-cross-origin',
      'robots': 'noindex',
      'og:type': 'website',
      'og:site_name': 'Tentura',
      'og:title': title,
      'og:description': description,
      'og:url': '$kServerName/shared/view?id=$id',
      'og:image': imagePath,
    };
