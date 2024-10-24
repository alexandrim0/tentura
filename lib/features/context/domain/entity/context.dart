import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/domain/entity/identifiable.dart';

part 'context.freezed.dart';

@freezed
class Context with _$Context implements Identifiable {
  const factory Context({
    @Default('') String name,
  }) = _Context;

  const Context._();

  @override
  String get id => name;
}
