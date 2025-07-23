export 'package:tentura_root/consts.dart';

// Numbers
const kMaxLines = 3;
const kCommentsShown = 3;
const kFetchWindowSize = 5;
const kSnackBarDuration = 5;
const kFetchListOffset = 0.9;
const kImageMaxDimension = 600;

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

const kAssetPackage = bool.fromEnvironment('IS_IMPORTED') ? 'tentura' : null;

final zeroAge = DateTime.fromMillisecondsSinceEpoch(0);
