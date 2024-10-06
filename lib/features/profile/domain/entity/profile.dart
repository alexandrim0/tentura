import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool hasAvatar,
    @Default(0) double score,
    @Default(0) int myVote,
  }) = _Profile;

  const Profile._();

  String get imageId => hasAvatar ? id : '';

  bool get isFriend => myVote > 0;
}
