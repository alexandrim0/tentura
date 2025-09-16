import 'package:jaspr/server.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';
import 'package:tentura_server/domain/entity/invitation_entity.dart';
import 'package:tentura_server/domain/entity/opinion_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';

import 'components/beacon_view_component.dart';
import 'components/comment_view_component.dart';
import 'components/opinion_view_component.dart';
import 'components/user_view_component.dart';
import 'styles/shared_view_styles.dart';

class SharedViewDocument extends StatelessComponent {
  const SharedViewDocument({
    required this.entity,
  });

  final Object entity;

  @override
  Component build(BuildContext context) => switch (entity) {
    // User
    final UserEntity user => _buildDocument(
      body: [
        UserViewComponent(user: user),
      ],
      meta: _buildMeta(
        id: user.id,
        title: user.title,
        description: user.description,
        imagePath: user.imageUrl,
      ),
    ),

    // Beacon
    final BeaconEntity beacon => _buildDocument(
      body: [
        BeaconViewComponent(beacon: beacon),
      ],
      meta: _buildMeta(
        id: beacon.id,
        title: beacon.title,
        description: beacon.description,
        imagePath: beacon.imageUrl,
      ),
    ),

    // Comment
    final CommentEntity comment => _buildDocument(
      body: [
        BeaconViewComponent(beacon: comment.beacon),
        CommentViewComponent(comment: comment),
      ],
      meta: _buildMeta(
        id: comment.id,
        title: comment.beacon.title,
        description: comment.content,
        imagePath: comment.beacon.imageUrl,
      ),
    ),

    // Invitation
    final InvitationEntity invitation => _buildDocument(
      body: [
        UserViewComponent(user: invitation.issuer),
        // TBD: InvitationViewComponent(user: invitation.issuer),
      ],
      meta: _buildMeta(
        id: invitation.id,
        title: invitation.issuer.title,
        // TBD: need real text with l10n
        description: 'Invite you to join Tentura!',
        imagePath: invitation.issuer.imageUrl,
      ),
    ),

    // Opinion
    final OpinionEntity opinion => _buildDocument(
      body: [
        UserViewComponent(user: opinion.user),
        OpinionViewComponent(opinion: opinion),
      ],
      meta: _buildMeta(
        id: opinion.id,
        title: opinion.user.title,
        description: opinion.content,
        imagePath: opinion.user.imageUrl,
      ),
    ),

    // Unsupported
    _ => throw Exception('Unsupported'),
  };

  Document _buildDocument({
    required List<Component> body,
    required Map<String, String> meta,
  }) => Document(
    title: kAppTitle,
    head: _headerLogo,
    meta: meta,
    body: div(
      body,
      classes: 'card',
      styles: const Styles(
        width: Unit.percent(100),
        overflow: Overflow.hidden,
      ),
    ),
    styles: defaultStyles,
  );

  static Map<String, String> _buildMeta({
    required String id,
    required String title,
    required String description,
    required String imagePath,
  }) => {
    'viewport':
        'width=device-width, initial-scale=1, '
        'minimum-scale=1, maximum-scale=1 user-scalable=no',
    'referrer': 'origin-when-cross-origin',
    'robots': 'noindex',
    'og:type': 'website',
    'og:site_name': 'Tentura',
    'og:title': title,
    'og:description': description,
    'og:url': '$kServerName/shared/view?id=$id',
    'og:image': imagePath,
  };

  static final _headerLogo = [
    link(
      href: '$kServerName$kPathIcons/web_24dp.png',
      rel: 'shortcut icon',
    ),
    link(
      href: '$kServerName$kPathIcons/web_32dp.png',
      rel: 'shortcut icon',
    ),
    link(
      href: '$kServerName$kPathIcons/web_36dp.png',
      rel: 'shortcut icon',
    ),
    link(
      href: '$kServerName$kPathIcons/web_48dp.png',
      rel: 'shortcut icon',
    ),
    link(
      href: '$kServerName$kPathIcons/web_64dp.png',
      rel: 'shortcut icon',
    ),
    link(
      href: '$kServerName$kPathIcons/web_96dp.png',
      rel: 'shortcut icon',
    ),
    link(
      href: '$kServerName$kPathIcons/web_512dp.png',
      rel: 'shortcut icon',
    ),
  ];
}
