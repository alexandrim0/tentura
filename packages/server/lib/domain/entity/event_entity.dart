import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/domain/enum.dart';

part 'event_entity.freezed.dart';

@freezed
class EventEntity with _$EventEntity {
  const factory EventEntity({
    required String id,
    required String table,
    required String schema,
    required String trigger,
    required String userId,
    required String userRole,
    required String queryContext,
    required DateTime createdAt,
    required HasuraOperation operation,
    Map<String, dynamic>? newData,
    Map<String, dynamic>? oldData,
  }) = _EventEntity;
}
