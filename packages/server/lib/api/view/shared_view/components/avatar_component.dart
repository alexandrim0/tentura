import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';

class AvatarComponent extends StatelessComponent {
  const AvatarComponent({
    required this.user,
  });

  final UserEntity user;

  @override
  Component build(BuildContext context) => fragment([
    img(
      src: user.imageUrl,
      classes: 'card-avatar__image',
      styles: const Styles(
        width: Unit.pixels(80),
        height: Unit.pixels(80),
      ),
    ),
    p(
      classes: 'card-avatar__text',
      styles: const Styles(
        fontSize: Unit.pixels(20),
        fontWeight: FontWeight.w600,
      ),
      [
        text(user.title),
      ],
    ),
  ]);
}
