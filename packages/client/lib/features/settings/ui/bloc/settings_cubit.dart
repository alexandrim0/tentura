import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/settings_repository.dart';
import 'settings_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'settings_state.dart';

/// Global Cubit
@singleton
class SettingsCubit extends Cubit<SettingsState> {
  @FactoryMethod(preResolve: true)
  static Future<SettingsCubit> hydrated(
    SettingsRepository repository,
  ) async {
    final isIntroEnabled = await repository.getIsIntroEnabled();
    final themeModeName = await repository.getThemeModeName();
    return SettingsCubit(
      repository: repository,
      state: SettingsState(
        introEnabled: isIntroEnabled,
        themeMode: ThemeMode.values.firstWhere(
          (themeMode) => themeMode.name == themeModeName,
          orElse: () => ThemeMode.system,
        ),
      ),
    );
  }

  SettingsCubit({
    required SettingsRepository repository,
    SettingsState state = const SettingsState(),
  })  : _repository = repository,
        super(state);

  final SettingsRepository _repository;

  @disposeMethod
  Future<void> dispose() => close();

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      await _repository.setThemeMode(themeMode.name);
      emit(state.copyWith(
        themeMode: themeMode,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> setIntroEnabled(bool isEnabled) async {
    try {
      await _repository.setIsIntroEnabled(isEnabled);
      emit(state.copyWith(
        introEnabled: isEnabled,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }
}
