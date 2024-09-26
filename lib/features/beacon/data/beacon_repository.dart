import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/gql/_g/schema.schema.gql.dart';
import 'package:tentura/data/service/remote_api_service.dart';

import 'model/beacon_model.dart';
import '../domain/exception.dart';
import '../domain/entity/beacon.dart';
import 'gql/_g/beacon_create.req.gql.dart';
import 'gql/_g/beacon_fetch_by_id.req.gql.dart';
import 'gql/_g/beacon_delete_by_id.req.gql.dart';
import 'gql/_g/beacon_update_by_id.req.gql.dart';
import 'gql/_g/beacons_fetch_by_user_id.req.gql.dart';

@lazySingleton
class BeaconRepository {
  static const _label = 'Beacon';

  BeaconRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Future<Beacon> fetchBeaconById(String beaconId) => _remoteApiService
      .request(GBeaconFetchByIdReq((b) => b.vars.id = beaconId))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).beacon_by_pk as BeaconModel?)
      .then((v) => v == null ? throw const BeaconFetchException() : v.toEntity);

  Future<Iterable<Beacon>> fetchBeaconsByUserId(String userId) =>
      _remoteApiService
          .request(GBeaconsFetchByUserIdReq((b) => b.vars.user_id = userId))
          .firstWhere((e) => e.dataSource == DataSource.Link)
          .then((r) => r.dataOrThrow(label: _label).beacon)
          .then((r) => r.map((e) => (e as BeaconModel).toEntity));

  Future<Beacon> create(Beacon beacon) => _remoteApiService
      .request(
        GBeaconCreateReq((b) => b.vars
          ..title = beacon.title
          ..context = beacon.context
          ..timerange = beacon.dateRange
          ..has_picture = beacon.hasPicture
          ..description = beacon.description
          ..long = beacon.coordinates?.long == null
              ? null
              : (Gfloat8Builder()
                ..replace(Gfloat8(beacon.coordinates!.long.toString())))
          ..lat = beacon.coordinates?.lat == null
              ? null
              : (Gfloat8Builder()
                ..replace(Gfloat8(beacon.coordinates!.lat.toString())))),
      )
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then(
        (r) => r.dataOrThrow(label: _label).insert_beacon_one as BeaconModel?,
      )
      .then(
        (v) => v == null ? throw const BeaconCreateException() : v.toEntity,
      );

  Future<void> delete(String id) => _remoteApiService
      .request(GBeaconDeleteByIdReq((b) => b.vars.id = id))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label));

  Future<Beacon> setEnabled({
    required String id,
    required bool isEnabled,
  }) =>
      _remoteApiService
          .request(GBeaconUpdateByIdReq(
            (b) => b
              ..vars.id = id
              ..vars.enabled = isEnabled,
          ))
          .firstWhere((e) => e.dataSource == DataSource.Link)
          .then((r) => r.dataOrThrow().update_beacon_by_pk as BeaconModel?)
          .then(
            (v) => v == null ? throw const BeaconUpdateException() : v.toEntity,
          );

  Future<void> putBeaconImage({
    required Uint8List image,
    required String beaconId,
  }) =>
      _remoteApiService.putBeaconImage(image, beaconId: beaconId);
}
