import 'package:injectable/injectable.dart';
import 'package:tentura_server/domain/entity/date_time_range.dart';

import 'package:tentura_server/domain/exception.dart';

import 'beacon_repository.dart';
import 'user_repository_mock.dart';

export 'package:tentura_server/domain/entity/beacon_entity.dart';

@Injectable(
  as: BeaconRepository,
  env: [
    Environment.test,
  ],
  order: 1,
)
class BeaconRepositoryMock implements BeaconRepository {
  @override
  Future<BeaconEntity> createBeacon(BeaconEntity beacon) async =>
      storageById[beacon.id] = beacon;

  @override
  Future<BeaconEntity> getBeaconById(String id) async =>
      storageById[id] ?? (throw IdNotFoundException(id));

  /// Mock data for tests and dev mode
  static final storageById = <String, BeaconEntity>{
    // Beacon with picture and comments
    'Bc1cb783b0159': BeaconEntity(
      id: 'Bc1cb783b0159',
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
      hasPicture: true,
      timerange: DateTimeRange(
        start: DateTime(2024, 10, 03),
        end: DateTime(2025, 10, 03),
      ),
      author: UserRepositoryMock.storageByPublicKey.values
          .singleWhere((e) => e.id == 'U286f94380611'),
    ),

    // Beacon without picture and comments
    'B20f3d51e498f': BeaconEntity(
      id: 'B20f3d51e498f',
      title: 'Protect Our Forests',
      description: '''
Dear citizens of Middle-earth, it has come to my attention that recent events have left our beloved forests in peril. The reckless antics of certain individuals, including those who claim to be guardians of our realm, have resulted in devastating fires that threaten our natural beauty and the cultural traditions intertwined with it.
As a concerned neighbor and advocate for the preservation of our environment, I urge each of you to join me in raising awareness and funds for the restoration of these precious lands. Together, we can combat the damage done and promote sustainable practices that honor both nature and our shared heritage.
Let us not forget: true guardianship means safeguarding our world for future generations. Remember, not all heroes wear capes—some hold the power of nature in their hands.''',
      createdAt: DateTime(2024, 10, 05, 09, 06, 32),
      updatedAt: DateTime(2024, 10, 05, 09, 06, 32),
      author: UserRepositoryMock.storageByPublicKey.values
          .singleWhere((e) => e.id == 'U4d9267c70eab'),
    ),
  };
}
