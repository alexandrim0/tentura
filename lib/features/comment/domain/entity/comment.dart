import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    required DateTime createdAt,
    @Default('') String id,
    @Default('') String beaconId,
    @Default('') String content,
    @Default(0) double score,
    @Default(0) int myVote,
    @Default(Profile()) Profile author,
  }) = _Comment;
}
