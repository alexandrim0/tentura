import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/utils/id.dart';

import 'user_entity.dart';

part 'opinion_entity.freezed.dart';

@freezed
abstract class OpinionEntity with _$OpinionEntity {
  static String get newId => generateId('O');

  const factory OpinionEntity({
    required String id,
    required String content,
    required UserEntity author,
    required UserEntity user,
    required DateTime createdAt,
    @Default(0) int score,
  }) = _OpinionEntity;

  const OpinionEntity._();
}
