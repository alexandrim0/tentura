import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_entity.freezed.dart';

@freezed
class ActionEntity with _$ActionEntity {
  const factory ActionEntity({
    required Map<String, dynamic> input,
    required String userId,
    required String userRole,
    required String queryContext,
  }) = _ActionEntity;
}
