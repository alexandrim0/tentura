// ignore_for_file: invalid_annotation_target //

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    @JsonKey(name: 'x-hasura-role') @Default('') String role,
    @JsonKey(name: 'x-hasura-user-id') @Default('') String userId,
    @JsonKey(name: 'x-hasura-query-context') @Default('') String queryContext,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}
