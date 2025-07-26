import 'package:injectable/injectable.dart';

import 'package:tentura/data/database/database.dart';

@singleton
class SettingsRepository {
  SettingsRepository(this._database);

  final Database _database;

  // AppId
  //
  Future<String?> getAppId() => _database.managers.settings
      .filter((f) => f.key.equals(_kAppIdKey))
      .getSingleOrNull()
      .then((v) => v?.valueText);

  //
  Future<bool> setAppId(String value) => _database.managers.settings.replace(
    SettingsCompanion(
      key: const Value(_kAppIdKey),
      valueText: Value(value),
    ),
  );

  // Last FCM registration
  //
  Future<DateTime?> getLastFcmRegistrationAt() => _database.managers.settings
      .filter((f) => f.key.equals(_kLastFcmRegistrationAtKey))
      .getSingleOrNull()
      .then(
        (v) => v?.valueText == null ? null : DateTime.tryParse(v!.valueText!),
      );

  //
  Future<void> setLastFcmRegistrationAt(DateTime value) =>
      _database.managers.settings.replace(
        SettingsCompanion(
          key: const Value(_kLastFcmRegistrationAtKey),
          valueText: Value(value.toIso8601String()),
        ),
      );

  // Intro
  //
  Future<bool?> getIsIntroEnabled() => _database.managers.settings
      .filter((f) => f.key.equals(_kIsIntroEnabledKey))
      .getSingleOrNull()
      .then((v) => v?.valueBool);

  //
  Future<void> setIsIntroEnabled(bool value) =>
      _database.managers.settings.replace(
        SettingsCompanion(
          key: const Value(_kIsIntroEnabledKey),
          valueBool: Value(value),
        ),
      );

  // Theme
  //
  Future<String?> getThemeModeName() => _database.managers.settings
      .filter((f) => f.key.equals(_kThemeModeKey))
      .getSingleOrNull()
      .then((v) => v?.valueText);

  //
  Future<void> setThemeMode(String value) => _database.managers.settings
      .filter((f) => f.key.equals(_kThemeModeKey))
      .update((o) => o(valueText: Value(value)));

  // Keys
  static const _kAppIdKey = 'appId';
  static const _kThemeModeKey = 'themeMode';
  static const _kIsIntroEnabledKey = 'isIntroEnabled';
  static const _kLastFcmRegistrationAtKey = 'lastFcmRegistrationAt';
}
