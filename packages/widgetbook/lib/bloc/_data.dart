import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/domain/entity/opinion.dart';
import 'package:tentura/domain/entity/profile.dart';

const idAlice = 'U0be96c3b9883';

const profileAlice = Profile(
  id: idAlice,
  title: 'Alice has 25 symbols here',
  description:
      'Friend of Bob. Alice is a passionate explorer of ideas, technology, '
      'and creativity. With a curious mind and a love for innovation, she '
      'thrives on solving complex problems and turning concepts into reality.',
  image: ImageEntity(
    id: '161f7ecf-ad75-4d8e-bb5d-842dc5794567',
    authorId: idAlice,
    height: 560,
    width: 528,
    blurHash:
        r'-{M7y1ay*0of-ofk%La}WBj@Rkay%2j@$yazM|fQbcj[Rkayj[jtxua|RjfQNGj@ofayRjj[t6j[t8fRRkfPoJfQWBjtaxa|t7az',
  ),
  score: 100,
);

const idBob = 'U5d33a9be1633';

const profileBob = Profile(
  id: idBob,
  title: 'Bob',
  description: 'Friend of Alice',
  image: ImageEntity(
    id: '196d6a86-9f83-4933-a0e3-ed486ce2d869',
    authorId: idBob,
    height: 563,
    width: 527,
    blurHash:
        '-UN^PXt8_Nt8bcog_Nxuoft7MxayMxxu9FofR*Rj?bs;D%ayxuWBD%aykCWB%MayNGWBs:WBt7WBsWWBkCWBkCRjIUWBxuWBt7WB',
  ),
  score: 100,
);

final beaconA = Beacon(
  createdAt: _now,
  updatedAt: _now,
  id: 'B0be96c3b9883',
  title: 'Beacon without description',
  author: profileAlice,
  myVote: 2,
  score: 50,
);

final beaconB = Beacon(
  createdAt: _now,
  updatedAt: _now,
  id: 'B5d33a9be1633',
  title: 'Beacon with description',
  description:
      'There should be some text here.\n'
      'And there one more string here.',
  author: profileAlice,
);

final List<Opinion> commentsOnAlice = [
  Opinion(
    id: 'cmt-1a2b3c',
    objectId: 'cmt-1a2b3c11',
    createdAt: DateTime(2025, 1, 31),
    content: 'Inspiring work, keep it up!',
    author: profileBob,
    amount: 0,
  ),
  Opinion(
    objectId: 'cmt-4d5e6f111',
    id: 'cmt-4d5e6f',
    createdAt: DateTime(2025, 1, 30),
    content:
        'I love how you approach challenges with creativity and determination. Your ideas are always fresh!',
    author: profileBob,
    amount: 1,
  ),
  Opinion(
    id: 'cmt-7g8h9i',
    objectId: 'cmt-7g8h9i111',
    createdAt: DateTime(2025, 1, 29),
    content:
        'Alice, your insights and passion for innovation are truly impressive. I’ve been following your work for a while, and I appreciate how you combine technology with creativity. Your problem-solving skills make a real difference, and I’m excited to see what you accomplish next. Keep pushing boundaries!',
    author: profileBob,
    amount: -1,
  ),
];

final _now = DateTime.now();
