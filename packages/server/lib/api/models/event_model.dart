import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/domain/entity/event_entity.dart';
import 'package:tentura_server/domain/enum.dart';

import 'session_model.dart';

part 'event_model.freezed.dart';

@freezed
abstract class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String table,
    required String schema,
    required String trigger,
    required DateTime createdAt,
    required SessionModel session,
    required HasuraOperation operation,
    Map<String, dynamic>? newData,
    Map<String, dynamic>? oldData,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as Map<String, dynamic>;
    final table = json['table'] as Map<String, dynamic>;
    final trigger = json['trigger'] as Map<String, dynamic>;
    final operation = (event['op']! as String).toLowerCase();
    final data = event['data'] as Map<String, dynamic>;
    return EventModel(
      id: json['id']! as String,
      table: table['name']! as String,
      schema: table['schema']! as String,
      trigger: trigger['name']! as String,
      newData: data['new'] as Map<String, dynamic>?,
      oldData: data['old'] as Map<String, dynamic>?,
      session: SessionModel.fromJson(
        event['session_variables']! as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at']! as String),
      operation: HasuraOperation.values.firstWhere((e) => e.name == operation),
    );
  }

  const EventModel._();

  EventEntity get asEntity => EventEntity(
    id: id,
    table: table,
    schema: schema,
    trigger: trigger,
    newData: newData,
    oldData: oldData,
    createdAt: createdAt,
    operation: operation,
    userRole: session.role,
    userId: session.userId,
    queryContext: session.queryContext,
  );
}
