import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';

import 'avatar_component.dart';

class UserViewComponent extends StatelessComponent {
  const UserViewComponent({
    required this.user,
  });

  final UserEntity user;

  @override
  Iterable<Component> build(BuildContext context) => [
        div(
          [
            div(
              [
                AvatarComponent(user: user),
              ],
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
}
