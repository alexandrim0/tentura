import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'identifiable.dart';
import 'profile.dart';

part 'polling.freezed.dart';

@freezed
abstract class Polling extends Identifiable with _$Polling {
  const factory Polling({
    required String question,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default({}) Map<String, String> variants,
    @Default({}) Set<String> selection,
    @Default(Profile()) Profile author,
    @Default(true) bool isEnabled,
    @Default('') String id,
  }) = _Polling;

  const Polling._();

  bool get hasChoice => selection.isNotEmpty;
  bool get hasNoChoice => selection.isEmpty;
}
