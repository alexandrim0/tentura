import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/comment_entity.dart';

import '../styles/shared_view_styles.dart';

class CommentViewComponent extends StatelessComponent {
  const CommentViewComponent({
    required this.comment,
  });

  final CommentEntity comment;

  @override
  Component build(BuildContext context) => fragment([
    hr(
      styles: const Styles(
        margin: Spacing.zero,
        border: Border.only(
          bottom: BorderSide.none(),
          top: BorderSide.solid(color: Color('#78839C')),
        ),
      ),
    ),
    div(
      styles: const Styles(
        display: Display.flex,
        padding: Spacing.only(
          left: kEdgeInsetsM,
          right: kEdgeInsetsM,
          bottom: kEdgeInsetsMS,
          top: kEdgeInsetsSXS,
        ),
        flexDirection: FlexDirection.row,
        flex: Flex(grow: 1),
        color: Color.variable('--comment-bg'),
      ),
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
          styles: const Styles(
            margin: Spacing.only(
              left: kEdgeInsetsM,
              top: kEdgeInsetsXS,
            ),
          ),
          [
            p(
              classes: 'card-avatar__text',
              styles: const Styles(
                margin: Spacing.only(bottom: kEdgeInsetsSXS),
                fontWeight: FontWeight.bolder,
              ),
              [
                text(comment.author.title),
              ],
            ),
            p(
              [
                text(comment.content),
              ],
            ),
          ],
        ),
      ],
    ),
  ]);
}
