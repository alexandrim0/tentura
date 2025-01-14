const kIdLength = 13;

const kCodeLength = 7;

const kTitleMinLength = 3;

const kTitleMaxLength = 32;

const kDescriptionLength = 2_048;

const kRatingSector = 100 / 4;

const kCommentsShown = 3;

const kMaxLines = 3;

const kUserAgent = 'Tentura';

const kSettingsThemeMode = 'themeMode';

const kSettingsIsIntroEnabledKey = 'isIntroEnabled';

const kAppLinkBase = 'https://${const String.fromEnvironment('APP_LINK_BASE')}';

const kOsmUrlTemplate = String.fromEnvironment(
  'OSM_LINK_BASE',
  defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
);

const kJwtExpiresIn = Duration(
  seconds: int.fromEnvironment(
    'JWT_EXPIRES_IN',
    defaultValue: 3_600,
  ),
);

const kSnackBarDuration = Duration(seconds: 5);
