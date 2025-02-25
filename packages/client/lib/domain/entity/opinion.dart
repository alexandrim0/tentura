import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'profile.dart';
import 'scorable.dart';

part 'opinion.freezed.dart';

@freezed
class Opinion with _$Opinion implements Scorable {
  const factory Opinion({
    required String id,
    required int amount,
    required String content,
    required String objectId,
    required DateTime createdAt,
    @Default(Profile()) Profile author,
    @Default(0) double score,
  }) = _Opinion;

  const Opinion._();

  @override
  double get reverseScore => 0;
}
