import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/remote_api_service.dart';

import '../../domain/entity/profile.dart';
import '../gql/_g/user_delete_by_id.req.gql.dart';
import '../gql/_g/user_fetch_by_id.req.gql.dart';
import '../gql/_g/user_update.req.gql.dart';

@singleton
class ProfileRemoteRepository {
  static const _label = 'Profile';

  const ProfileRemoteRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Future<Profile?> fetch(String id) => _remoteApiService
      .request(GUserFetchByIdReq((b) => b.vars.id = id))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).user_by_pk)
      .then(
        (r) => r == null
            ? null
            : Profile(
                id: r.id,
                title: r.title,
                description: r.description,
                hasAvatar: r.has_picture,
              ),
      );

  Future<Profile?> update(Profile profile) => _remoteApiService
      .request(GUserUpdateReq((b) => b.vars
        ..id = profile.id
        ..title = profile.title
        ..description = profile.description
        ..has_picture = profile.hasAvatar))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).update_user_by_pk)
      .then(
        (r) => r == null
            ? null
            : Profile(
                id: r.id,
                title: r.title,
                description: r.description,
                hasAvatar: r.has_picture,
              ),
      );

  Future<String> delete(String id) => _remoteApiService
      .request(GUserDeleteByIdReq((b) => b.vars.id = id))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).delete_user_by_pk!.id);

  Future<void> putAvatarImage(Uint8List image) =>
      _remoteApiService.putAvatarImage(image);
}
