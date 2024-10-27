import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/entity/likable.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile implements Likable {
  const factory Profile({
    @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool hasAvatar,
    @Default(0) double rScore,
    @Default(0) double score,
    @Default(0) int myVote,
  }) = _Profile;

  const Profile._();

  @override
  int get votes => myVote;

  String get imageId => hasAvatar ? id : '';

  bool get isFriend => myVote > 0;

  bool get isSeeingMe => rScore > 0;

  bool get needEdit => id.isNotEmpty && title.isEmpty;
}
