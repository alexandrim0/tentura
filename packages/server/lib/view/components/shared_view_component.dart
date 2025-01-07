import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';

class SharedViewComponent extends StatelessComponent {
  const SharedViewComponent({
    required this.entity,
  });

  final Object entity;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      switch (entity) {
        final UserEntity user => _buildUserContent(user),
        final BeaconEntity beacon => _buildBeaconContent(beacon),
        final CommentEntity comment => [
            ..._buildBeaconContent(comment.beacon),
            ..._buildCommentContainer(comment)
          ],
        _ => throw Exception('Unsupported'),
      },
      classes: 'card',
      styles: const Styles.box(
        width: Unit.percent(100),
        overflow: Overflow.hidden,
      ),
    );
  }

  List<Component> _buildUserContent(UserEntity user) => [
        div(
          [
            div(
              _buildAvatarContent(user),
              classes: 'card-avatar',
            ),
            if (user.description.isNotEmpty)
              p(
                [
                  text(user.description),
                ],
                styles: const Styles.box(
                  margin: EdgeInsets.only(
                    top: Unit.pixels(24),
                  ),
                ),
              ),
          ],
          classes: 'card-container',
        ),
      ];

  List<Component> _buildAvatarContent(UserEntity user) => [
        img(
          src: user.imageUrl,
          classes: 'card-avatar__image',
          styles: const Styles.box(
            width: Unit.pixels(80),
            height: Unit.pixels(80),
          ),
        ),
        p(
          [
            text(user.title),
          ],
          classes: 'card-avatar__text',
          styles: const Styles.text(
            fontSize: Unit.pixels(20),
            fontWeight: FontWeight.w600,
          ),
        ),
      ];

  List<Component> _buildBeaconContent(BeaconEntity beacon) => [
        img(
          src: beacon.imageUrl,
          styles: const Styles.box(
            width: Unit.percent(100),
          ),
        ),
        div(
          [
            div(
              _buildAvatarContent(beacon.author),
              classes: 'card-avatar',
              styles: const Styles.box(
                margin: EdgeInsets.only(
                  top: Unit.pixels(-68),
                ),
              ),
            ),
            h1(
              [
                text(beacon.title),
              ],
              styles: const Styles.box(
                margin: EdgeInsets.only(
                  top: Unit.pixels(24),
                ),
              ),
            ),
            if (beacon.description.isNotEmpty)
              p(
                [
                  text(beacon.description),
                ],
                styles: const Styles.box(
                  margin: EdgeInsets.only(
                    top: Unit.pixels(16),
                  ),
                ),
              ),
            if (beacon.coordinates != null)
              p(
                [
                  text(beacon.coordinates.toString()),
                ],
                classes: 'secondary-text',
                styles: const Styles.box(
                  margin: EdgeInsets.only(
                    top: Unit.pixels(16),
                    bottom: Unit.pixels(8),
                  ),
                ),
              ),
            if (beacon.timerange != null)
              p(
                [
                  text(beacon.timerange.toString()),
                ],
                classes: 'secondary-text',
              ),
          ],
          classes: 'card-container',
        ),
      ];

  List<Component> _buildCommentContainer(CommentEntity comment) => [
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
