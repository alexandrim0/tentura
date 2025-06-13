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
    required Map<String, String> variants,
    @Default(Profile()) Profile author,
    @Default(true) bool isEnabled,
    @Default('') String id,
  }) = _Polling;

  const Polling._();
}
