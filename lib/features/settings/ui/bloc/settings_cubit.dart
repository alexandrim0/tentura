import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/settings_repository.dart';
import 'settings_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'settings_state.dart';

@singleton
class SettingsCubit extends Cubit<SettingsState> {
  @FactoryMethod(preResolve: true)
  static Future<SettingsCubit> hydrated(SettingsRepository repository) async =>
      SettingsCubit(
        repository: repository,
        state: SettingsState(
          themeMode: await repository.getThemeMode(),
          introEnabled: await repository.getIsIntroEnabled(),
        ),
      );

  SettingsCubit({
    required SettingsRepository repository,
    SettingsState state = const SettingsState(),
  })  : _repository = repository,
        super(state);

  final SettingsRepository _repository;

  @disposeMethod
  Future<void> dispose() => close();

  Future<void> setThemeMode(ThemeMode themeMode) async => emit(state.copyWith(
        themeMode: await _repository.setThemeMode(themeMode),
      ));

  Future<void> setIntroEnabled(bool isEnabled) async => emit(state.copyWith(
        introEnabled: await _repository.setIsIntroEnabled(isEnabled),
      ));
}
