import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/like_remote_repository.dart';
import '../entity/likable_entity.dart';
import '../typedef.dart';

@lazySingleton
class LikeCase {
  LikeCase({
    required AuthRepository authRepository,
    required LikeRemoteRepository likeRemoteRepository,
  })  : _authRepository = authRepository,
        _likeRemoteRepository = likeRemoteRepository;

  final AuthRepository _authRepository;
  final LikeRemoteRepository _likeRemoteRepository;

  Stream<LikeAmount> get likeChanges => _likeRemoteRepository.changes;

  Stream<String> get currentAccountChanges =>
      _authRepository.currentAccountChanges();

  Future<void> addLikeAmount({
    required LikableEntity entity,
    required int amount,
  }) =>
      switch (entity) {
        final LikableBeacon _ => _likeRemoteRepository.likeBeacon(
            beaconId: entity.id,
            amount: amount,
          ),
        final LikableComment _ => _likeRemoteRepository.likeComment(
            commentId: entity.id,
            amount: amount,
          ),
        final LikableProfile _ => _likeRemoteRepository.likeUser(
            userId: entity.id,
            amount: amount,
          ),
      };
}
