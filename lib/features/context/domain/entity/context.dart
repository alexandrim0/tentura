import 'package:freezed_annotation/freezed_annotation.dart';

part 'context.freezed.dart';

@freezed
sealed class Context with _$Context {
  const factory Context.add() = ContextAdd;

  const factory Context.all() = ContextAll;

  const factory Context.value(String name) = ContextValue;
}
