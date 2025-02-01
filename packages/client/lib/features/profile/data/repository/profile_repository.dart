import 'dart:async';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/model/user_model.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';

import '../../domain/exception.dart';
import '../gql/_g/user_delete_by_id.req.gql.dart';
import '../gql/_g/user_fetch_by_id.req.gql.dart';
import '../gql/_g/user_update.req.gql.dart';

@singleton
class ProfileRepository {
  ProfileRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  final _controller = StreamController<RepositoryEvent<Profile>>.broadcast();

  Stream<RepositoryEvent<Profile>> get changes => _controller.stream;

  @disposeMethod
  Future<void> dispose() => _controller.close();

  Future<Profile> fetch(String id) async {
    final response = await _remoteApiService
        .request(GUserFetchByIdReq((b) => b.vars.id = id))
        .firstWhere((e) => e.dataSource == DataSource.Link)
        .then((r) => r.dataOrThrow(label: _label).user_by_pk)
        .then((r) => (r as UserModel?)?.toEntity);
    if (response == null) throw ProfileFetchException(id);
    _controller.add(RepositoryEventFetch(response));
    return response;
  }

  Future<void> update(Profile profile) async {
    final response = await _remoteApiService
        .request(GUserUpdateReq((b) => b.vars
          ..id = profile.id
          ..title = profile.title
          ..description = profile.description
          ..has_picture = profile.hasAvatar))
        .firstWhere((e) => e.dataSource == DataSource.Link)
        .then(
          (r) => r.dataOrThrow(label: _label).update_user_by_pk as UserModel?,
        );
    if (response == null) throw ProfileUpdateException(profile.id);
    _controller.add(RepositoryEventUpdate(response.toEntity));
  }

  Future<void> delete(String id) async {
    final response = await _remoteApiService
        .request(GUserDeleteByIdReq((b) => b.vars.id = id))
        .firstWhere((e) => e.dataSource == DataSource.Link)
        .then((r) => r.dataOrThrow(label: _label).delete_user_by_pk);
    if (response == null) throw ProfileDeleteException(id);
    _controller.add(RepositoryEventDelete(Profile(id: response.id)));
  }

  Future<void> putAvatarImage({
    required Uint8List image,
    required String id,
  }) =>
      _remoteApiService.uploadImage(
        image: image,
        id: id,
      );

  static const _label = 'Profile';
}
