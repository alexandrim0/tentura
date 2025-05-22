import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/utils/id.dart';

import 'beacon_entity.dart';
import 'user_entity.dart';

part 'comment_entity.freezed.dart';

@freezed
abstract class CommentEntity with _$CommentEntity {
  static String get newId => generateId('C');

  const factory CommentEntity({
    required String id,
    required String content,
    required UserEntity author,
    required BeaconEntity beacon,
    required DateTime createdAt,
  }) = _CommentEntity;
}
