import 'package:jaspr/server.dart';
import 'package:tentura_server/consts.dart';

import 'package:tentura_server/data/model/shared_view_model.dart';

class SharedViewComponent extends StatelessComponent {
  const SharedViewComponent({
    required this.model,
  });

  final Object model;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
        classes: 'card',
        styles: const Styles.box(
          width: Unit.percent(100),
          overflow: Overflow.hidden,
        ),
        switch (model) {
          final SharedViewModelUser model => [
              div(
                [
                  div(_buildAvatarContent(model), classes: 'card-avatar'),
                  if (model.description.isNotEmpty)
                    p(
                      [text(model.description)],
                      styles: const Styles.box(
                        margin: EdgeInsets.only(top: Unit.pixels(24)),
                      ),
                    )
                ],
                classes: 'card-container',
              )
            ],
          final SharedViewModelBeacon model => _buildBeaconContent(model),
          final SharedViewModelComment model =>
            _buildBeaconContent(model.beacon) + _buildCommentContainer(model),
          _ => throw Exception('Unsupported'),
        });
  }

  List<Component> _buildAvatarContent(SharedViewModelUser model) => [
        img(
          src:
              'http${kIsHttps ? 's' : ''}://$kServerName/${model.imagePath}.jpg',
          classes: 'card-avatar__image',
          styles: const Styles.box(
            width: Unit.pixels(80),
            height: Unit.pixels(80),
          ),
        ),
        p(
          [text(model.title)],
          classes: 'card-avatar__text',
          styles: const Styles.text(
              fontSize: Unit.pixels(20), fontWeight: FontWeight.w600),
        ),
      ];

  List<Component> _buildBeaconContent(SharedViewModelBeacon model) => [
        img(
            src:
                'http${kIsHttps ? 's' : ''}://$kServerName/${model.imagePath}.jpg',
            styles: const Styles.box(width: Unit.percent(100))),
        div(
          [
            div(
              _buildAvatarContent(model.author),
              classes: 'card-avatar',
              styles: const Styles.box(
                margin: EdgeInsets.only(top: Unit.pixels(-68)),
              ),
            ),
            h1(
              [text(model.title)],
              styles: const Styles.box(
                margin: EdgeInsets.only(top: Unit.pixels(24)),
              ),
            ),
            if (model.description.isNotEmpty)
              p(
                [text(model.description)],
                styles: const Styles.box(
                  margin: EdgeInsets.only(top: Unit.pixels(16)),
                ),
              ),
            if (model.place.isNotEmpty)
              p(
                [text(model.place)],
                classes: 'secondary-text',
                styles: const Styles.box(
                  margin: EdgeInsets.only(
                    top: Unit.pixels(16),
                    bottom: Unit.pixels(8),
                  ),
                ),
              ),
            if (model.time.isNotEmpty)
              p(
                [text(model.time)],
                classes: 'secondary-text',
              ),
          ],
          classes: 'card-container',
        ),
      ];

  List<Component> _buildCommentContainer(SharedViewModelComment model) => [
        hr(
          styles: const Styles.box(
            margin: EdgeInsets.zero,
            border: Border.only(
              top: BorderSide.solid(color: Color.hex('#78839C')),
              bottom: BorderSide.none(),
            ),
          ),
        ),
        div(
          [
            img(
              src:
                  'http${kIsHttps ? 's' : ''}://$kServerName/${model.commentor.imagePath}.jpg',
              classes: 'card-avatar__image',
              styles: const Styles.combine([
                Styles.box(
                  width: Unit.pixels(60),
                  height: Unit.pixels(60),
                  minWidth: Unit.pixels(60),
                )
              ]),
            ),
            div(
              [
                p(
                  [text(model.commentor.title)],
                  classes: 'card-avatar__text',
                  styles: const Styles.combine(
                    [
                      Styles.text(fontWeight: FontWeight.bolder),
                      Styles.box(
                        margin: EdgeInsets.only(bottom: Unit.pixels(12)),
                      )
                    ],
                  ),
                ),
                p([text(model.content)])
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
              Styles.flexbox(direction: FlexDirection.row),
              Styles.raw({'flex-grow': '1'}),
              Styles.box(
                padding: EdgeInsets.only(
                  left: Unit.pixels(16),
                  right: Unit.pixels(16),
                  bottom: Unit.pixels(24),
                  top: Unit.pixels(8),
                ),
              ),
              Styles.background(color: Color.variable('--comment-bg'))
            ],
          ),
        )
      ];
}
