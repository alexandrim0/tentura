// Numbers

const kIdLength = 13;

const kTitleMinLength = 3;

const kTitleMaxLength = 32;

const kDescriptionLength = 2_048;

const kRatingSector = 100 / 4;

const kJwtExpiresIn = 3_600;

const kAuthJwtExpiresIn = 30;

// Strings

const kAppTitle = 'Tentura';

const kPathIcons = '/icons';

const kPathLogin = '/api/user/login';
const kPathRegister = '/api/user/register';
const kPathImageUpload = '/api/user/image_upload';
const kPathGraphQLEndpoint = '/api/v1/graphql';
const kPathAppLinkView = '/shared/view';

const kUserAgent = kAppTitle;

const kContentTypeHtml = 'text/html';
const kContentTypeJpeg = 'image/jpeg';

const kHeaderContentType = 'Content-Type';
const kHeaderAuthorization = 'Authorization';
const kHeaderQueryContext = 'X-Hasura-Query-Context';

const kImageExt = 'jpg';
const kImagesPath = 'images';
const kAvatarPlaceholderUrl = '$kImageServer/$kImagesPath/placeholder/avatar.jpg';
const kBeaconPlaceholderUrl = '$kImageServer/$kImagesPath/placeholder/beacon.jpg';

/// First part of FQDN: `https://app.server.name`
const kServerName = String.fromEnvironment('SERVER_NAME');

/// First part of FQDN: `https://image.server.name`
const kImageServer = String.fromEnvironment('IMAGE_SERVER');
