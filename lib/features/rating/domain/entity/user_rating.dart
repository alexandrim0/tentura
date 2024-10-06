import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

part 'user_rating.freezed.dart';

@freezed
class UserRating with _$UserRating {
  const factory UserRating({
    required double egoScore,
    required double userScore,
    required Profile profile,
  }) = _UserRating;
}
