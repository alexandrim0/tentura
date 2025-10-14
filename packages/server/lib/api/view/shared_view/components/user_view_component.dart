import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';

import '../styles/shared_view_styles.dart';
import 'avatar_component.dart';

class UserViewComponent extends StatelessComponent {
  const UserViewComponent({
    required this.user,
  });

  final UserEntity user;

  @override
  Component build(BuildContext context) => fragment([
    div(
      classes: 'card-container',
      [
        div(
          classes: 'card-avatar',
          [
            AvatarComponent(user: user),
          ],
        ),
        if (user.description.isNotEmpty)
          p(
            styles: const Styles(
              margin: Spacing.only(top: kEdgeInsetsMS),
            ),
            [
              text(user.description),
            ],
          ),
      ],
    ),
  ]);
}
