import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/consts.dart';

import 'likable.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile implements Likable {
  const factory Profile({
    @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool hasAvatar,
    @Default('') String blurhash,
    @Default(0) int imageHeight,
    @Default(0) int imageWidth,
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

  String get avatarUrl => '$kImageServer/$kImagesPath/$id/avatar.$kImageExt?'
      '${blurhash.replaceRange(5, blurhash.length - 5, '')}';
}
