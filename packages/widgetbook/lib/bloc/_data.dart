import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/profile.dart';

const profileAlice = Profile(
  id: 'U0be96c3b9883',
  title: 'Alice',
  description: 'Friend of Bob',
  hasAvatar: true,
);

const profileBob = Profile(
  id: 'U5d33a9be1633',
  title: 'Bob',
  description: 'Friend of Alice',
  hasAvatar: true,
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

final _now = DateTime.now();
