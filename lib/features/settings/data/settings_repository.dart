import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:tentura/data/service/local_secure_storage.dart';

@singleton
class SettingsRepository {
  static const _repositoryKey = 'Settings:';
  static const _themeModeKey = '${_repositoryKey}themeMode';
  static const _isIntroEnabledKey = '${_repositoryKey}isIntroEnabled';

  SettingsRepository(this._storage);

  final LocalSecureStorage _storage;

  Future<bool> getIsIntroEnabled() => _storage.read(_isIntroEnabledKey).then(
        (value) => bool.tryParse(value ?? '') ?? true,
      );
  Future<bool> setIsIntroEnabled(bool value) =>
      _storage.write(_isIntroEnabledKey, value.toString()).then((_) => value);

  Future<ThemeMode> getThemeMode() => _storage.read(_themeModeKey).then(
        (value) => ThemeMode.values.firstWhere(
          (themeMode) => themeMode.name == value,
          orElse: () => ThemeMode.system,
        ),
      );

  Future<ThemeMode> setThemeMode(ThemeMode value) =>
      _storage.write(_themeModeKey, value.name).then((_) => value);
}
