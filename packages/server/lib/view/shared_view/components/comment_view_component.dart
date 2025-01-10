import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/comment_entity.dart';

class CommentViewComponent extends StatelessComponent {
  const CommentViewComponent({
    required this.comment,
  });

  final CommentEntity comment;

  @override
  Iterable<Component> build(BuildContext context) => [
        hr(
          styles: const Styles.box(
            border: Border.only(
              bottom: BorderSide.none(),
              top: BorderSide.solid(
                color: Color.hex('#78839C'),
              ),
            ),
            margin: EdgeInsets.zero,
          ),
        ),
        div(
          [
            img(
              src: comment.author.imageUrl,
              classes: 'card-avatar__image',
              styles: const Styles.box(
                width: Unit.pixels(60),
                height: Unit.pixels(60),
                minWidth: Unit.pixels(60),
              ),
            ),
            div(
              [
                p(
                  [
                    text(comment.author.title),
                  ],
                  classes: 'card-avatar__text',
                  styles: const Styles.combine(
                    [
                      Styles.text(
                        fontWeight: FontWeight.bolder,
                      ),
                      Styles.box(
                        margin: EdgeInsets.only(
                          bottom: Unit.pixels(12),
                        ),
                      )
                    ],
                  ),
                ),
                p(
                  [
                    text(comment.content),
                  ],
                )
              ],
              styles: const Styles.box(
                margin: EdgeInsets.only(
                  left: Unit.pixels(16),
                  top: Unit.pixels(4),
                ),
              ),
            ),
          ],
          styles: const Styles.combine(
            [
              Styles.flexbox(
                direction: FlexDirection.row,
              ),
              Styles.raw(
                {
                  'flex-grow': '1',
                },
              ),
              Styles.box(
                padding: EdgeInsets.only(
                  left: Unit.pixels(16),
                  right: Unit.pixels(16),
                  bottom: Unit.pixels(24),
                  top: Unit.pixels(8),
                ),
              ),
              Styles.background(
                color: Color.variable('--comment-bg'),
              )
            ],
          ),
        ),
      ];
}
