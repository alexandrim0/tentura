import 'package:flutter/material.dart';

import 'package:tentura/ui/bloc/state_base.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState, StateFetchMixin {
  const factory SettingsState({
    @Default('en') String locale,
    @Default(true) bool introEnabled,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _SettingsState;

  const SettingsState._();

  SettingsState setLoading() => copyWith(status: FetchStatus.isLoading);

  SettingsState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
