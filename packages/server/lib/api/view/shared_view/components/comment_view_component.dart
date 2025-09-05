import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/comment_entity.dart';

import '../styles/shared_view_styles.dart';

class CommentViewComponent extends StatelessComponent {
  const CommentViewComponent({
    required this.comment,
  });

  final CommentEntity comment;

  @override
  Component build(BuildContext context) => Component.fragment([
    hr(
      styles: const Styles(
        border: Border.only(
          bottom: BorderSide.none(),
          top: BorderSide.solid(color: Color('#78839C')),
        ),
        margin: Spacing.zero,
      ),
    ),
    div(
      [
        img(
          src: comment.author.imageUrl,
          classes: 'card-avatar__image',
          styles: const Styles(
            width: Unit.pixels(60),
            height: Unit.pixels(60),
            minWidth: Unit.pixels(60),
          ),
        ),
        div(
          [
            p(
              [text(comment.author.title)],
              classes: 'card-avatar__text',
              styles: const Styles(
                fontWeight: FontWeight.bolder,
                margin: Spacing.only(bottom: kEdgeInsetsSXS),
              ),
            ),
            p([
              text(comment.content),
            ]),
          ],
          styles: const Styles(
            margin: Spacing.only(
              left: kEdgeInsetsM,
              top: kEdgeInsetsXS,
            ),
          ),
        ),
      ],
      styles: const Styles(
        display: Display.flex,
        flex: Flex(grow: 1),
        flexDirection: FlexDirection.row,
        padding: Spacing.only(
          left: kEdgeInsetsM,
          right: kEdgeInsetsM,
          bottom: kEdgeInsetsMS,
          top: kEdgeInsetsSXS,
        ),
        color: Color.variable('--comment-bg'),
      ),
    ),
  ]);
}
