export 'package:tentura_root/consts.dart';

const kMaxLines = 3;

const kCommentsShown = 3;

const kSnackBarDuration = 5;

const kImageMaxDimension = 600;

const kImageQuality = 95;

const kSettingsThemeMode = 'themeMode';

const kSettingsIsIntroEnabledKey = 'isIntroEnabled';

const kPathRoot = '/';
const kPathGraph = '/graph';
const kPathRating = '/rating';
const kPathConnect = '/connect';
const kPathBeaconNew = '/beacon/new';
const kPathBeaconView = '/beacon/view';
const kPathProfileChat = '/profile/chat';
const kPathProfileEdit = '/profile/edit';
const kPathProfileView = '/profile/view';

const kOsmUrlTemplate = String.fromEnvironment(
  'OSM_LINK_BASE',
  defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
);

const kAssetPackage = bool.fromEnvironment('IS_IMPORTED') ? 'tentura' : null;
