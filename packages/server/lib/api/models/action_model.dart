import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/domain/entity/action_entity.dart';

import 'session_model.dart';

part 'action_model.freezed.dart';
part 'action_model.g.dart';

@freezed
abstract class ActionModel with _$ActionModel {
  const factory ActionModel({
    // ignore: invalid_annotation_target //
    @JsonKey(name: 'session_variables') required SessionModel session,
    required Map<String, dynamic> action,
    required Map<String, dynamic> input,
  }) = _ActionModel;

  factory ActionModel.fromJson(Map<String, dynamic> json) =>
      _$ActionModelFromJson(json);

  const ActionModel._();

  String? get name => action['name'] as String?;

  ActionEntity get asEntity => ActionEntity(
    input: input,
    userId: session.userId,
    userRole: session.role,
    queryContext: session.queryContext,
  );
}
