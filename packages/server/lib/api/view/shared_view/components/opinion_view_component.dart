import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/opinion_entity.dart';

import '../styles/shared_view_styles.dart';
import 'avatar_component.dart';

class OpinionViewComponent extends StatelessComponent {
  const OpinionViewComponent({
    required this.opinion,
  });

  final OpinionEntity opinion;

  @override
  Component build(BuildContext context) => fragment([
    div(
      classes: 'card-container',
      [
        div(
          classes: 'card-avatar',
          [
            AvatarComponent(user: opinion.author),
          ],
        ),
        p(
          styles: const Styles(
            margin: Spacing.only(top: kEdgeInsetsS),
          ),
          [
            text(opinion.content),
          ],
        ),
        p(
          classes: 'secondary-text',
          styles: const Styles(
            margin: Spacing.only(top: kEdgeInsetsXS),
          ),
          [
            text(_formatDate(opinion.createdAt)),
          ],
        ),
      ],
    ),
  ]);

  static String _formatDate(DateTime dateTime) =>
      '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)}';

  static String _pad(int number) => number.toString().padLeft(2, '0');
}
