import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entity/profile.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String title,
    required String description,
    required bool hasPicture,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, Object?> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromEntity(Profile entity) => ProfileModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        hasPicture: entity.hasAvatar,
      );

  const ProfileModel._();

  Profile get toEntity => Profile(
        id: id,
        title: title,
        description: description,
        hasAvatar: hasPicture,
      );
}
