import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';
import 'package:tentura/features/like/data/repository/like_remote_repository.dart';

import '../../data/repository/friends_remote_repository.dart';

@lazySingleton
class FriendsCase {
  FriendsCase(
    this._likeRemoteRepository,
    this._friendsRemoteRepository,
  );

  final LikeRemoteRepository _likeRemoteRepository;

  final FriendsRemoteRepository _friendsRemoteRepository;

  Stream<Profile> get friendsChanges => _likeRemoteRepository.changes
      .where((e) => e.value is Profile)
      .map((e) => e.value as Profile);

  Future<Iterable<Profile>> fetch() => _friendsRemoteRepository.fetch();

  Future<Profile> addFriend(Profile user) =>
      _likeRemoteRepository.setLike(user, amount: 1);

  Future<Profile> removeFriend(Profile user) =>
      _likeRemoteRepository.setLike(user, amount: 0);
}
