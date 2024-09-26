import 'package:tentura/features/beacon/domain/entity/beacon.dart';
import 'package:tentura/features/comment/domain/entity/comment.dart';
import 'package:tentura/features/profile/domain/entity/profile.dart';

sealed class LikableEntity {
  const LikableEntity();

  String get id;
  int get likeAmount;

  @override
  String toString() => 'Can`t set [$likeAmount] like amount for [$id]';
}

final class LikableBeacon extends LikableEntity {
  const LikableBeacon(this.value);

  final Beacon value;

  @override
  String get id => value.id;

  @override
  int get likeAmount => value.myVote;
}

final class LikableComment extends LikableEntity {
  const LikableComment(this.value);

  final Comment value;

  @override
  String get id => value.id;

  @override
  int get likeAmount => value.myVote;
}

final class LikableProfile extends LikableEntity {
  const LikableProfile(this.value);

  final Profile value;

  @override
  String get id => value.id;

  @override
  int get likeAmount => value.myVote;
}
