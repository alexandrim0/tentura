// TBD: move not void public methods into state
// ignore_for_file: prefer_void_public_cubit_methods

// TBD: return string instead of ThemeMode?
// ignore: avoid_flutter_imports
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/settings_repository.dart';
import 'settings_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'settings_state.dart';

/// Global Cubit
@singleton
class SettingsCubit extends Cubit<SettingsState> {
  @FactoryMethod(preResolve: true)
  static Future<SettingsCubit> hydrated(
    AuthRepository authRepository,
    SettingsRepository repository,
  ) async {
    final isIntroEnabled = await repository.getIsIntroEnabled();
    final themeModeName = await repository.getThemeModeName();
    return SettingsCubit(
      authRepository: authRepository,
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
    required AuthRepository authRepository,
    required SettingsRepository repository,
    SettingsState state = const SettingsState(),
  }) : _authRepository = authRepository,
       _repository = repository,
       super(state);

  final AuthRepository _authRepository;

  final SettingsRepository _repository;

  @disposeMethod
  Future<void> dispose() => close();

  Future<({String id, String seed})> getAccountSeed() async {
    final accountId = await _authRepository.getCurrentAccountId();
    final seed = await _authRepository.getSeedByAccountId(accountId);
    return (id: accountId, seed: seed);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      await _repository.setThemeMode(themeMode.name);
      emit(state.copyWith(themeMode: themeMode));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> setIntroEnabled(bool isEnabled) async {
    try {
      await _repository.setIsIntroEnabled(isEnabled);
      emit(state.copyWith(introEnabled: isEnabled));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(status: StateIsNavigating.back()));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
