import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/consts.dart';

import 'coordinates.dart';
import 'likable.dart';
import 'polling.dart';
import 'profile.dart';

part 'beacon.freezed.dart';

@freezed
abstract class Beacon with _$Beacon implements Likable {
  const factory Beacon({
    required DateTime createdAt,
    required DateTime updatedAt,
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
    Coordinates? coordinates,
    Polling? polling,
    DateTime? startAt,
    DateTime? endAt,
  }) = _Beacon;

  const Beacon._();

  @override
  int get votes => myVote;

  bool get hasNoPicture => !hasPicture;

  bool get hasPolling => polling != null;

  bool get hasNoPolling => polling == null;

  String get imageUrl => hasPicture
      ? '$kImageServer/$kImagesPath/${author.id}/$id.$kImageExt'
      : kBeaconPlaceholderUrl;
}

final emptyBeacon = Beacon(
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
);
