import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/likable.dart';
import 'package:tentura/domain/entity/repository_event.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/like_remote_repository.dart';

@lazySingleton
class LikeCase {
  LikeCase({
    required AuthRepository authRepository,
    required LikeRemoteRepository likeRemoteRepository,
  })  : _authRepository = authRepository,
        _likeRemoteRepository = likeRemoteRepository;

  final AuthRepository _authRepository;

  final LikeRemoteRepository _likeRemoteRepository;

  Stream<RepositoryEvent<Likable>> get likeChanges =>
      _likeRemoteRepository.changes;

  Stream<String> get currentAccountChanges =>
      _authRepository.currentAccountChanges();

  Future<void> setLikeAmount({
    required Likable entity,
    required int amount,
  }) =>
      _likeRemoteRepository.setLike(entity, amount: amount);
}
