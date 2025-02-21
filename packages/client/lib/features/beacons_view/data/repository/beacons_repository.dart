import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/model/beacon_model.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/beacon.dart';

import '../gql/_g/beacons_fetch_by_user_id.req.gql.dart';

@lazySingleton
class BeaconsRepository {
  BeaconsRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Future<Iterable<Beacon>> fetchBeaconsByUserId({
    required String id,
    int offset = 0,
    int limit = 10,
  }) => _remoteApiService
      .request(
        GBeaconsFetchByUserIdReq(
          (b) =>
              b.vars
                ..user_id = id
                ..limit = limit
                ..offset = offset,
        ),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).beacon)
      .then((v) => v.map((e) => (e as BeaconModel).toEntity));

  static const _label = 'BeaconsView';
}
