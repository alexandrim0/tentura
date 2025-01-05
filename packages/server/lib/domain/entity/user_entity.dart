import 'package:freezed_annotation/freezed_annotation.dart';

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

  String get imagePath => '';
}
