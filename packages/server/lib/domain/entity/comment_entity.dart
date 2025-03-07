import 'package:freezed_annotation/freezed_annotation.dart';

import 'beacon_entity.dart';
import 'user_entity.dart';

part 'comment_entity.freezed.dart';

@freezed
class CommentEntity with _$CommentEntity {
  const factory CommentEntity({
    required String id,
    required String content,
    required UserEntity author,
    required BeaconEntity beacon,
    required DateTime createdAt,
  }) = _CommentEntity;
}
