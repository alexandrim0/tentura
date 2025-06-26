import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';

const kAnonymousKey = '0E_W6fNl_e9zk-YtRWlHTNVQnTBkxK2csCtfkdxeCVc';
const kDainKey = '60qBqhlXQzNOvlgK9h1FdxzpZX18EcC2A-6vqr_ABu8';
const kGandalfKey = 'DpywC3XZqDJFLyey0w11Ms1dX2I1RWgEl5Ps-tONuo8';
const kPussyCatKey = '2CmIb3Ho2eb6m8WIog6KiyzCY05sbyX04PiGlH5baDw';
const kThorinKey = 'iqjH7nwdD1CBa-XgaW90yY443ghL8RC0Za-hKv-aeGg';

/// Mock data for tests and dev mode
const kUserByPublicKey = <String, UserEntity>{
  // Thorin Oakenshield
  kThorinKey: UserEntity(
    id: 'U286f94380611',
    title: 'Thorin Oakenshield',
    description: 'Son of Thrain, son of Thror, King under the Mountain',
    // TBD: add image parameters
  ),

  // Dain Ironfoot
  kDainKey: UserEntity(
    id: 'U8ebde6fbfd3f',
    title: 'Dain Ironfoot',
    description: '''
CEO of Ironfoot Industries and the Lord of the Iron Hills. Veteran in resource extraction and heavy manufacturing. When the chips are down, I’m the guy you want in your corner. Tough decisions? I make them every day. 👊 Always looking for the next big opportunity in heavy industry and infrastructure.''',
    // TBD: add image parameters
  ),

  // Gandalf
  kGandalfKey: UserEntity(
    id: 'U2becfc64c13b',
    title: 'Gandalf the Gray',
    description: '''
Experienced business angel and startup mentor with a knack for turning risky ventures into legendary success stories. Disrupting the market since before it was cool. Occasionally disappear to let teams find their own path, but always return at the right moment. DM for networking and strategic advice.''',
    // TBD: add image parameters
  ),

  // User without picture
  kAnonymousKey: UserEntity(
    id: 'U4d9267c70eab',
    title: 'The Anonymous of Dol Guldur',
    description: '''
Let's save the nature and cultural traditions of Middle-earth! 

Activist, publicist, concerned neighbor and representative of one of the largest communities in Middle-earth.''',
  ),

  // User for auth test
  kPussyCatKey: UserEntity(id: 'U3ea0a229ad85', title: 'Pussy Cat'),
};

const kB20f3d51e498f = 'B20f3d51e498f';
const kBc1cb783b0159 = 'Bc1cb783b0159';

/// Mock data for tests and dev mode
final kBeaconById = <String, BeaconEntity>{
  // Beacon with picture and comments
  kBc1cb783b0159: BeaconEntity(
    id: kBc1cb783b0159,
    title: 'The Quest for Glory Awaits!',
    description: '''
Durin's Kin, our noble company seeks valiant souls to join us in our grand endeavor to reclaim the Lonely Mountain from the vile Smaug. If you possess the heart of a true dwarf and the mettle to face fire and darkness, we welcome your blade and your courage. Our quest is not for the faint-hearted, but for those who yearn for honor and glory.

Requirements:
 – Expertise with axe or sword
 – An appreciation for fine gold and gemcraft
 – A robust constitution to withstand dragon fire and goblin ambushes

If you are bold enough to stand among dwarves of valor, reply to this call or send a raven. Please, only those who are committed to the cause and not easily deterred by peril. And kindly, leave behind those who speak only of their uncles’ exaggerated tales of elvish grandeur. Our journey is fraught with danger, but for those who stand with us, there is a treasure beyond dreams and tales of heroism.''',
    context: 'QuestForGlory',
    createdAt: DateTime(2024, 10, 03),
    updatedAt: DateTime(2024, 10, 03),
    startAt: DateTime(2024, 10, 03),
    endAt: DateTime(2025, 10, 03),
    // TBD: add image parameters
    author: kUserByPublicKey[kThorinKey]!,
  ),

  // Beacon without picture and comments
  kB20f3d51e498f: BeaconEntity(
    id: kB20f3d51e498f,
    title: 'Protect Our Forests',
    description: '''
Dear citizens of Middle-earth, it has come to my attention that recent events have left our beloved forests in peril. The reckless antics of certain individuals, including those who claim to be guardians of our realm, have resulted in devastating fires that threaten our natural beauty and the cultural traditions intertwined with it.
As a concerned neighbor and advocate for the preservation of our environment, I urge each of you to join me in raising awareness and funds for the restoration of these precious lands. Together, we can combat the damage done and promote sustainable practices that honor both nature and our shared heritage.
Let us not forget: true guardianship means safeguarding our world for future generations. Remember, not all heroes wear capes—some hold the power of nature in their hands.''',
    createdAt: DateTime(2024, 10, 05, 09, 06, 32),
    updatedAt: DateTime(2024, 10, 05, 09, 06, 32),
    author: kUserByPublicKey[kAnonymousKey]!,
  ),
};

const kC1b28e93382e1 = 'C1b28e93382e1';
const kC9b1d2b73215c = 'C9b1d2b73215c';

/// Mock data for tests and dev mode
final kCommentById = <String, CommentEntity>{
  kC9b1d2b73215c: CommentEntity(
    id: kC9b1d2b73215c,
    content: '14. I`ve got us a burglar.',
    createdAt: DateTime(2024, 10, 05, 10, 25, 54),
    beacon: kBeaconById[kBc1cb783b0159]!,
    author: kUserByPublicKey[kGandalfKey]!,
  ),
  kC1b28e93382e1: CommentEntity(
    id: kC1b28e93382e1,
    content:
        'Sorry, cousin, my boar is allergic to dragons. '
        'Wish you all the luck though!',
    createdAt: DateTime(2024, 10, 05, 10, 23, 28),
    beacon: kBeaconById[kBc1cb783b0159]!,
    author: kUserByPublicKey[kDainKey]!,
  ),
};
