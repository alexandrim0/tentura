import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates.dart';
import 'likable.dart';
import 'profile.dart';

part 'beacon.freezed.dart';

@freezed
class Beacon with _$Beacon implements Likable {
  const factory Beacon({
    required DateTime createdAt,
    required DateTime updatedAt,
    Coordinates? coordinates,
    DateTimeRange? dateRange,
    @Default('') String id,
    @Default('') String title,
    @Default('') String context,
    @Default('') String blurhash,
    @Default('') String description,
    @Default(false) bool isPinned,
    @Default(false) bool isEnabled,
    @Default(false) bool hasPicture,
    @Default(0) int imageHeight,
    @Default(0) int imageWidth,
    @Default(0) double rScore,
    @Default(0) double score,
    @Default(0) int myVote,
    @Default(Profile()) Profile author,
  }) = _Beacon;

  const Beacon._();

  @override
  int get votes => myVote;
}

final emptyBeacon = Beacon(
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
);
