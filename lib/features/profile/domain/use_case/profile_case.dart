import 'dart:async';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/profile_local_repository.dart';
import '../../data/repository/profile_remote_repository.dart';
import '../entity/profile.dart';

@lazySingleton
class ProfileCase {
  ProfileCase({
    required AuthRepository authRepository,
    required ProfileLocalRepository profileLocalRepository,
    required ProfileRemoteRepository profileRemoteRepository,
  })  : _authRepository = authRepository,
        _profileLocalRepository = profileLocalRepository,
        _profileRemoteRepository = profileRemoteRepository;

  final AuthRepository _authRepository;
  final ProfileLocalRepository _profileLocalRepository;
  final ProfileRemoteRepository _profileRemoteRepository;

  Stream<String> get currentAccountChanges =>
      _authRepository.currentAccountChanges();

  Future<Profile> fetch(
    String id, {
    bool fromCache = true,
  }) async {
    final cached = await _profileLocalRepository.getProfileById(id);
    if (fromCache && cached != null) return cached;
    final profile = await _profileRemoteRepository.fetch(id);
    if (cached != profile!) await _profileLocalRepository.setProfile(profile);
    return profile;
  }

  Future<Profile> update(Profile profile) async {
    await _profileRemoteRepository.update(profile);
    await _profileLocalRepository.setProfile(profile);
    return profile;
  }

  Future<String> delete(String id) async {
    await _profileRemoteRepository.delete(id);
    await _profileLocalRepository.deleteProfileById(id);
    return id;
  }

  Future<void> putAvatarImage(Uint8List image) =>
      _profileRemoteRepository.putAvatarImage(image);
}
