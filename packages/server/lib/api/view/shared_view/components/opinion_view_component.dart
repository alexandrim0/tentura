import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/opinion_entity.dart';

import '../styles/shared_view_styles.dart';
import 'avatar_component.dart';

class OpinionViewComponent extends StatelessComponent {
  const OpinionViewComponent({required this.opinion});

  final OpinionEntity opinion;

  @override
  Iterable<Component> build(BuildContext context) => [
    div([
      div([AvatarComponent(user: opinion.author)], classes: 'card-avatar'),
      p([
        text(opinion.content),
      ], styles: const Styles(margin: Spacing.only(top: kEdgeInsetsS))),
      p(
        [text(_formatDate(opinion.createdAt))],
        classes: 'secondary-text',
        styles: const Styles(margin: Spacing.only(top: kEdgeInsetsXS)),
      ),
    ], classes: 'card-container'),
  ];

  static String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)}';
  }

  static String _pad(int number) => number.toString().padLeft(2, '0');
}
