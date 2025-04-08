import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  static String get newId => generateId('U');

  const factory UserEntity({
    required String id,
    @Default('') String publicKey,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool hasPicture,
    @Default('') String blurHash,
    @Default(0) int picHeight,
    @Default(0) int picWidth,
  }) = _UserEntity;

  const UserEntity._();

  Map<String, Object> get asJson => {'id': id};

  String get imageUrl =>
      hasPicture
          ? '$kImageServer/$kImagesPath/$id/avatar.$kImageExt'
          : kImageServer + kAvatarPlaceholderUrl;
}
