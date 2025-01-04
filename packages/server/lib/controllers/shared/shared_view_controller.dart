// ignore_for_file: prefer_const_declarations //

import 'package:jaspr/server.dart';
import 'package:tentura_server/view/styles/_styles.dart';

import 'package:tentura_server/view/utils/header.dart';
import 'package:tentura_server/view/components/shared_view_component.dart';
import 'package:tentura_server/view/utils/meta.dart';

Future<Response> sharedViewController(Request request) async {
  late final String ogId;
  late final String ogTitle;
  late final String ogDescription;
  late final String ogImagePath;
  late final Object model;
  switch (request.requestedUri.queryParameters['id']) {
    case final String userId when userId.startsWith('U'):
      model = _user;
      ogId = userId;
      ogTitle = _user.title;
      ogDescription = _user.description;
      ogImagePath = _user.imagePath;

    case final String beaconId when beaconId.startsWith('B'):
      model = _beacon;
      ogId = beaconId;
      ogTitle = _beacon.title;
      ogDescription = _beacon.description;
      ogImagePath = _beacon.imagePath;

    case final String commentId when commentId.startsWith('C'):
      model = _comment;
      ogId = commentId;
      ogTitle = _beacon.title;
      ogDescription = _comment.content;
      ogImagePath = _beacon.imagePath;

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
    headers: {'Content-Type': 'text/html'},
  );
}

final _user = (
  id: '',
  title: 'Пендальф Серый',
  description:
      'Начальники никогда не опаздывают, Фёдор Сумкин, и рано они тоже не приходят, они приходят строго тогда, когда считают нужным!',
  imagePath: 'static/img/avatar-placeholder',
);
final _beacon = (
  id: '',
  title: 'Клерки',
  description:
      'Ты когда-нибудь замечал, что все цены заканчиваются на девятку? Черт, это пугает.',
  place: '',
  time: '',
  author: _user,
  imagePath: 'static/img/image-placeholder',
);

final _comment = (
  id: '',
  content: 'Зачем тебе пистолет? Дави их интеллектом!',
  beacon: _beacon,
  commentor: _user,
  imagePath: '',
);
