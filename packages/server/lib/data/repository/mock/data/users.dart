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
  kPussyCatKey: UserEntity(
    id: 'U3ea0a229ad85',
    title: 'Pussy Cat',
  ),
};
