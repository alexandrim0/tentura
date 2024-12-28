import 'package:freezed_annotation/freezed_annotation.dart';

part 'context_selection.freezed.dart';

@freezed
sealed class ContextSelection with _$ContextSelection {
  const factory ContextSelection.add() = ContextSelectionAdd;

  const factory ContextSelection.all() = ContextSelectionAll;

  const factory ContextSelection.value(String name) = ContextSelectionValue;
}
