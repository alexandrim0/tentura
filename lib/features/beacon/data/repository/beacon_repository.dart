import 'dart:async';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/gql/_g/schema.schema.gql.dart';
import 'package:tentura/data/model/beacon_model.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/repository_event.dart';

import '../../domain/exception.dart';
import '../gql/_g/beacon_create.req.gql.dart';
import '../gql/_g/beacon_fetch_by_id.req.gql.dart';
import '../gql/_g/beacon_delete_by_id.req.gql.dart';
import '../gql/_g/beacon_update_by_id.req.gql.dart';
import '../gql/_g/beacons_fetch_by_user_id.req.gql.dart';

@lazySingleton
class BeaconRepository {
  static const _label = 'Beacon';

  BeaconRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  final _controller = StreamController<RepositoryEvent<Beacon>>.broadcast();

  Stream<RepositoryEvent<Beacon>> get changes => _controller.stream;

  @disposeMethod
  Future<void> dispose() => _controller.close();

  Future<Beacon> fetchBeaconById(String id) => _remoteApiService
      .request(GBeaconFetchByIdReq((b) => b.vars.id = id))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).beacon_by_pk as BeaconModel?)
      .then((v) => v == null ? throw BeaconFetchException(id) : v.toEntity);

  Future<Iterable<Beacon>> fetchBeaconsByUserId(String id) => _remoteApiService
      .request(GBeaconsFetchByUserIdReq((b) => b.vars.user_id = id))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).beacon)
      .then((v) => v.map((e) => (e as BeaconModel).toEntity));

  Future<Beacon> create(Beacon beacon) async {
    final response = await _remoteApiService
        .request(
          GBeaconCreateReq((b) => b.vars
            ..title = beacon.title
            ..timerange = beacon.dateRange
            ..has_picture = beacon.hasPicture
            ..description = beacon.description
            ..context = beacon.context.isEmpty ? null : beacon.context
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
        .then((r) => r.dataOrThrow(label: _label).insert_beacon_one);
    if (response == null) throw BeaconCreateException(beacon);
    final result = (response as BeaconModel).toEntity;
    _controller.add(RepositoryEventCreate(result));
    return result;
  }

  Future<void> delete(String id) => _remoteApiService
      .request(GBeaconDeleteByIdReq((b) => b.vars.id = id))
      .firstWhere((e) => e.dataSource == DataSource.Link)
      .then((r) => r.dataOrThrow(label: _label).delete_beacon_by_pk)
      .then(
        (v) => v == null
            ? BeaconDeleteException(id)
            : _controller.add(RepositoryEventDelete(emptyBeacon.copyWith(
                id: id,
              ))),
      );

  Future<void> setEnabled(
    bool isEnabled, {
    required String id,
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
            (v) => v == null
                ? throw BeaconUpdateException(id)
                : _controller.add(RepositoryEventUpdate(v.toEntity)),
          );

  Future<void> putBeaconImage({
    required Uint8List image,
    required String beaconId,
  }) =>
      _remoteApiService.putBeaconImage(image, beaconId: beaconId);
}
