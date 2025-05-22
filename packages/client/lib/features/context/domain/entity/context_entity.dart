import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/entity/identifiable.dart';

part 'context_entity.freezed.dart';

@freezed
abstract class ContextEntity with _$ContextEntity implements Identifiable {
  const factory ContextEntity({@Default('') String name}) = _ContextEntity;

  const ContextEntity._();

  @override
  String get id => name;
}
