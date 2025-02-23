import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'likable.dart';
import 'profile.dart';
import 'scorable.dart';

part 'opinion.freezed.dart';

@freezed
class Opinion with _$Opinion implements Likable, Scorable {
  const factory Opinion({
    required String id,
    required String content,
    required String objectId,
    required DateTime createdAt,
    @Default(0) double score,
    @Default(0) int votes,
    @Default(Profile()) Profile author,
  }) = _Opinion;

  const Opinion._();

  @override
  double get reverseScore => 0;
}
