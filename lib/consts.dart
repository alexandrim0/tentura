// Numbers

const kIdLength = 13;

const kTitleMinLength = 3;

const kTitleMaxLength = 32;

const kPublicKeyLength = 44;

const kDescriptionMaxLength = 2_048;

const kRatingSector = 100 / 4;

/// In seconds
const kJwtExpiresIn = 3_600;

const kAuthJwtExpiresIn = 30;

const kRequestTimeout = 15;

/// In hours
const kInvitationDefaultTTL = 24 * 7;

// Strings

const kAppTitle = 'Tentura';

const kPathIcons = '/icons';

const kPathAppLinkView = '/shared/view';
const kPathGraphQLEndpoint = '/api/v1/graphql';
const kPathGraphQLEndpointV2 = '/api/v2/graphql';

const kUserAgent = kAppTitle;

const kContentTypeHtml = 'text/html';
const kContentTypeJpeg = 'image/jpeg';
const kContentApplicationJson = 'application/json';

const kHeaderAccept = 'Accept';
const kHeaderUserAgent = 'User-Agent';
const kHeaderContentType = 'Content-Type';
const kHeaderAuthorization = 'Authorization';
const kHeaderQueryContext = 'X-Hasura-Query-Context';

const kImageExt = 'jpg';
const kImagesPath = 'images';
const kAvatarPlaceholderUrl =
    '$kImageServer/$kImagesPath/placeholder/avatar.$kImageExt';
const kBeaconPlaceholderUrl =
    '$kImageServer/$kImagesPath/placeholder/beacon.$kImageExt';

/// First part of FQDN: `https://app.server.name`
const kServerName = String.fromEnvironment('SERVER_NAME');

/// First part of FQDN: `https://image.server.name`
const kImageServer = String.fromEnvironment('IMAGE_SERVER');

const kAvatarPlaceholderBlurhash =
    ':QPjJjoL?bxu~qRjD%xuM{j[%MayIUj[t7j[~qa{xuWBD%of%MWBRjj[j[ayxuj[M{ay?bj[IT'
    'WBayofayWBxuayRjofofWBWBj[Rjj[t7ayRjayRjofs:fQfQfRWBj[ofay';
