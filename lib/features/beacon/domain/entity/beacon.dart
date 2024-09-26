import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/entity/geo.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

part 'beacon.freezed.dart';

@freezed
class Beacon with _$Beacon {
  const factory Beacon({
    required DateTime createdAt,
    required DateTime updatedAt,
    Coordinates? coordinates,
    DateTimeRange? dateRange,
    @Default('') String id,
    @Default('') String title,
    @Default('') String context,
    @Default('') String description,
    @Default(false) bool hasPicture,
    @Default(false) bool isEnabled,
    @Default(false) bool isPinned,
    @Default(0) int commentsCount,
    @Default(0) int myVote,
    @Default(Profile()) Profile author,
  }) = _Beacon;

  const Beacon._();

  String get imageId => hasPicture ? id : '';
}
