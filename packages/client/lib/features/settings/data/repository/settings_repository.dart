import 'package:injectable/injectable.dart';

import 'package:tentura/data/database/database.dart';

@singleton
class SettingsRepository {
  SettingsRepository(this._database);

  final Database _database;

  Future<bool> getIsIntroEnabled() => _database.managers.settings
      .filter((f) => f.key.equals(_kSettingsIsIntroEnabledKey))
      .getSingleOrNull()
      .then((v) => v?.valueBool ?? true);

  Future<void> setIsIntroEnabled(bool value) => _database.managers.settings
      .filter((f) => f.key.equals(_kSettingsIsIntroEnabledKey))
      .update((o) => o(valueBool: Value(value)));

  Future<String?> getThemeModeName() => _database.managers.settings
      .filter((f) => f.key.equals(_kSettingsThemeMode))
      .getSingleOrNull()
      .then((v) => v?.valueText ?? 'system');

  Future<void> setThemeMode(String value) => _database.managers.settings
      .filter((f) => f.key.equals(_kSettingsThemeMode))
      .update((o) => o(valueText: Value(value)));

  static const _kSettingsThemeMode = 'themeMode';
  static const _kSettingsIsIntroEnabledKey = 'isIntroEnabled';
}
