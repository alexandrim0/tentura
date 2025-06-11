import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/utils/id.dart';

import 'user_entity.dart';

part 'polling_entity.freezed.dart';

@freezed
abstract class PollingEntity with _$PollingEntity {
  static String get newId => generateId('P');

  const factory PollingEntity({
    required String id,
    required String question,
    required UserEntity author,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isEnabled,
    @Default([]) List<String> variants,
  }) = _PollingEntity;

  const PollingEntity._();

  Map<String, Object> get asJson => {'id': id};
}
