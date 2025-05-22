// ignore_for_file: deprecated_member_use //

import 'package:jaspr/server.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';

class AvatarComponent extends StatelessComponent {
  const AvatarComponent({required this.user});

  final UserEntity user;

  @override
  Iterable<Component> build(BuildContext context) => [
    img(
      src: user.imageUrl,
      classes: 'card-avatar__image',
      styles: const Styles.box(width: Unit.pixels(80), height: Unit.pixels(80)),
    ),
    p(
      [text(user.title)],
      classes: 'card-avatar__text',
      styles: const Styles.text(
        fontSize: Unit.pixels(20),
        fontWeight: FontWeight.w600,
      ),
    ),
  ];
}
