import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/opinion.dart';
import 'package:tentura/domain/entity/profile.dart';

const profileAlice = Profile(
  id: 'U0be96c3b9883',
  title: 'Alice has 25 symbols here',
  description:
      'Friend of Bob. Alice is a passionate explorer of ideas, technology, '
      'and creativity. With a curious mind and a love for innovation, she '
      'thrives on solving complex problems and turning concepts into reality.',
  hasAvatar: true,
  score: 100,
);

const profileBob = Profile(
  id: 'U5d33a9be1633',
  title: 'Bob',
  description: 'Friend of Alice',
  hasAvatar: true,
  score: 100,
);

final beaconA = Beacon(
  createdAt: _now,
  updatedAt: _now,
  id: 'A',
  title: 'Beacon A',
  author: profileAlice,
  myVote: 2,
  score: 50,
);

final beaconB = Beacon(
  createdAt: _now,
  updatedAt: _now,
  id: 'B',
  title: 'Beacon B',
  author: profileAlice,
);

final List<Opinion> commentsOnAlice = [
  Opinion(
    id: 'cmt-1a2b3c',
    objectId: 'cmt-1a2b3c11',
    createdAt: DateTime(2025, 1, 31),
    content: 'Inspiring work, keep it up!',
    author: profileBob,
  ),
  Opinion(
    objectId: 'cmt-4d5e6f111',
    id: 'cmt-4d5e6f',
    createdAt: DateTime(2025, 1, 30),
    content:
        'I love how you approach challenges with creativity and determination. Your ideas are always fresh!',
    author: profileBob,
  ),
  Opinion(
    id: 'cmt-7g8h9i',
    objectId: 'cmt-7g8h9i111',
    createdAt: DateTime(2025, 1, 29),
    content:
        'Alice, your insights and passion for innovation are truly impressive. I’ve been following your work for a while, and I appreciate how you combine technology with creativity. Your problem-solving skills make a real difference, and I’m excited to see what you accomplish next. Keep pushing boundaries!',
    author: profileBob,
  ),
];

final _now = DateTime.now();
