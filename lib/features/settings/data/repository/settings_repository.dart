import 'package:injectable/injectable.dart';

import 'package:tentura/data/database/database.dart';

@singleton
class SettingsRepository {
  SettingsRepository(this._database);

  final Database _database;

  Future<bool> getIsIntroEnabled() => (_database.settings.select()
        ..where((t) => t.key.equals(_isIntroEnabledKey)))
      .getSingleOrNull()
      .then((v) => v?.valueBool ?? true);

  Future<void> setIsIntroEnabled(bool value) =>
      _database.settings.insertOnConflictUpdate(SettingsCompanion.insert(
        key: _isIntroEnabledKey,
        valueBool: Value(value),
      ));

  Future<String?> getThemeModeName() =>
      (_database.settings.select()..where((t) => t.key.equals(_themeModeKey)))
          .getSingleOrNull()
          .then((v) => v?.valueText);

  Future<void> setThemeMode(String value) => _database.settings
      .insertOnConflictUpdate(SettingsCompanion.insert(
        key: _themeModeKey,
        valueText: Value(value),
      ))
      .then((_) => value);

  static const _themeModeKey = 'themeMode';
  static const _isIntroEnabledKey = 'isIntroEnabled';
}
