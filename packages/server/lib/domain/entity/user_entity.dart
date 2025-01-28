import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/consts.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool hasPicture,
  }) = _UserEntity;

  const UserEntity._();

  String get imageUrl => hasPicture
      ? '$kImageServer/images/$id/avatar.jpg'
      : kImageServer + kAvatarPlaceholderUrl;
}
