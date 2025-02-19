import 'package:injectable/injectable.dart';

import 'package:tentura/data/model/opinion_model.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/opinion.dart';

import '../../domain/exception.dart';
import '../gql/_g/opinion_create.req.gql.dart';
import '../gql/_g/opinion_remove_by_id.req.gql.dart';
import '../gql/_g/opinions_fetch_by_object_id.req.gql.dart';

@lazySingleton
class OpinionRepository {
  OpinionRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Future<List<Opinion>> fetchByObjectId({
    required String objectId,
    required int offset,
    required int limit,
  }) => _remoteApiService
      .request(
        GOpinionsFetchByObjectIdReq(
          (b) =>
              b.vars
                ..objectId = objectId
                ..offset = offset
                ..limit = limit,
        ),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).opinion)
      .then((v) => v.map((e) => (e as OpinionModel).toEntity).toList());

  Future<Opinion> createOpinion({
    required String objectId,
    required String content,
  }) => _remoteApiService
      .request(
        GOpinionCreateReq(
          (b) =>
              b.vars
                ..objectId = objectId
                ..content = content,
        ),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).insert_opinion_one)
      .then(
        (v) =>
            v == null
                ? throw const OpinionCreateException()
                : Opinion(
                  id: v.id,
                  content: content,
                  objectId: objectId,
                  createdAt: v.created_at,
                ),
      );

  Future<void> removeOpinionById(String id) => _remoteApiService
      .request(GOpinionRemoveByIdReq((b) => b.vars.id = id))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label));

  static const _label = 'Opinion';
}
