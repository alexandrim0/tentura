import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/beacon.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/favorites_remote_repository.dart';

@lazySingleton
class FavoritesCase {
  const FavoritesCase({
    required AuthRepository authRepository,
    required FavoritesRemoteRepository favoritesRemoteRepository,
  })  : _authRepository = authRepository,
        _favoritesRemoteRepository = favoritesRemoteRepository;

  final AuthRepository _authRepository;

  final FavoritesRemoteRepository _favoritesRemoteRepository;

  Stream<Beacon> get favoritesChanges => _favoritesRemoteRepository.changes;

  Stream<String> get currentAccountChanges =>
      _authRepository.currentAccountChanges();

  Future<Iterable<Beacon>> fetch() => _favoritesRemoteRepository.fetch();

  Future<void> pin(Beacon beacon) => _favoritesRemoteRepository.pin(beacon);

  Future<void> unpin({
    required String userId,
    required Beacon beacon,
  }) =>
      _favoritesRemoteRepository.unpin(
        userId: userId,
        beacon: beacon,
      );
}
