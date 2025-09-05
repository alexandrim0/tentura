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
  Component build(BuildContext context) => Component.fragment([
    div(
      [
        div(
          [AvatarComponent(user: user)],
          classes: 'card-avatar',
        ),
        if (user.description.isNotEmpty)
          p(
            [text(user.description)],
            styles: const Styles(margin: Spacing.only(top: kEdgeInsetsMS)),
          ),
      ],
      classes: 'card-container',
    ),
  ]);
}
