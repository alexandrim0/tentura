import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/remote_api_service.dart';

import 'gql/_g/context_add.req.gql.dart';
import 'gql/_g/context_delete.req.gql.dart';
import 'gql/_g/context_fetch.req.gql.dart';

@singleton
class ContextRepository {
  static const _label = 'Context';

  ContextRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  final _fetchRequest = GContextFetchReq();

  Future<Iterable<String>> fetch() => _remoteApiService
      .request(_fetchRequest)
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then(
        (r) => r
            .dataOrThrow(label: _label)
            .user_context
            .map((r) => r.context_name),
      );

  Future<String?> add(String contextName) => _remoteApiService
      .request(GContextAddReq((b) => b.vars.context_name = contextName))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) =>
          r.dataOrThrow(label: _label).insert_user_context_one?.context_name);

  Future<String?> delete({
    required String userId,
    required String contextName,
  }) =>
      _remoteApiService
          .request(GContextDeleteReq((b) => b.vars
            ..user_id = userId
            ..context_name = contextName))
          .firstWhere((e) => e.dataSource == DataSource.Link)
          .then((r) => r
              .dataOrThrow(label: _label)
              .delete_user_context_by_pk
              ?.context_name);
}
