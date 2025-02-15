import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/consts.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool hasPicture,
    @Default('') String blurHash,
    @Default(0) int picHeight,
    @Default(0) int picWidth,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  const UserEntity._();

  String get imageUrl =>
      hasPicture
          ? '$kImageServer/$kImagesPath/$id/avatar.$kImageExt'
          : kImageServer + kAvatarPlaceholderUrl;
}
