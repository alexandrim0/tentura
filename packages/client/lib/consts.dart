export 'package:tentura_root/consts.dart';

const kMaxLines = 3;

const kCommentsShown = 3;

const kSnackBarDuration = 5;

const kFetchWindowSize = 5;

const kFetchListOffset = 0.9;

// Images
const kImageQuality = 95;
const kImageMaxDimension = 600;

// Assets
const kAssetAvatarPlaceholder = 'images/placeholder/avatar.jpg';
const kAssetBeaconPlaceholder = 'images/placeholder/beacon.jpg';

// Settings storage keys
// TBD: replace with enum
const kSettingsThemeMode = 'themeMode';
const kSettingsIsIntroEnabledKey = 'isIntroEnabled';

// Routes
const kPathBack = '/back';
const kPathHome = '/home';
const kPathMyField = '/home/field';
const kPathConnect = '/home/connect';
const kPathFriends = '/home/friends';
const kPathProfile = '/home/profile';
const kPathFavorites = '/home/favorites';
const kPathGraph = '/graph';
const kPathRating = '/rating';
const kPathSignIn = '/sign/in';
const kPathSignUp = '/sign/up';
const kPathSettings = '/settings';
const kPathComplaint = '/complaint';
const kPathBeaconNew = '/beacon/new';
const kPathBeaconView = '/beacon/view';
const kPathBeaconViewAll = '/beacon/all';
const kPathProfileChat = '/profile/chat';
const kPathProfileEdit = '/profile/edit';
const kPathProfileView = '/profile/view';
const kPathInvitations = '/invitations';

const kComplaintEmail = String.fromEnvironment(
  'COMPLAINT_EMAIL',
  defaultValue: 'complaint@intersubjective.space',
);

const kOsmUrlTemplate = String.fromEnvironment(
  'OSM_LINK_BASE',
  defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
);

const kNeedInviteCode = bool.fromEnvironment('NEED_INVITE_CODE');

const kAssetPackage = bool.fromEnvironment('IS_IMPORTED') ? 'tentura' : null;
