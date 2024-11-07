import 'dart:convert';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/local_secure_storage.dart';

import '../../domain/entity/profile.dart';
import '../model/profile_model.dart';

@singleton
class ProfileLocalRepository {
  static const _repositoryKey = 'Profile:';
  static const _profileKey = '${_repositoryKey}Id:';

  ProfileLocalRepository(this._localStorage);

  final LocalSecureStorage _localStorage;

  Future<Profile?> getProfileById(String id) => _localStorage
      .read('$_profileKey$id')
      .then((v) => switch (jsonDecode(v ?? 'null')) {
            final Map<String, dynamic> j => ProfileModel.fromJson(j).toEntity,
            _ => null,
          });

  Future<Profile> setProfile(Profile profile) => _localStorage
      .write(
        '$_profileKey${profile.id}',
        jsonEncode(ProfileModel.fromEntity(profile).toJson()),
      )
      .then((_) => profile);

  Future<String> deleteProfileById(String id) =>
      _localStorage.write('$_profileKey$id', null).then((_) => id);
}
