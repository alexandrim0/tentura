import 'package:tentura_root/domain/entity/coordinates.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';

import '../database/tentura_db.dart';
import 'polling_mapper.dart';
import 'user_mapper.dart';

mixin BeaconMapper on UserMapper, PollingMapper {
  BeaconEntity beaconModelToEntity(
    Beacon model, {
    required User author,
    Polling? polling,
    List<PollingVariant>? variants,
  }) => BeaconEntity(
    id: model.id,
    title: model.title,
    context: model.context,
    isEnabled: model.isEnabled,
    description: model.description,
    author: userModelToEntity(author),
    createdAt: model.createdAt.dateTime,
    updatedAt: model.updatedAt.dateTime,
    hasPicture: model.hasPicture,
    picHeight: model.picHeight,
    picWidth: model.picWidth,
    blurHash: model.blurHash,
    startAt: model.startAt?.dateTime,
    endAt: model.endAt?.dateTime,
    polling: polling == null
        ? null
        : pollingModelToEntity(polling, author: author, variants: variants),
    coordinates: model.lat != null && model.long != null
        ? Coordinates(lat: model.lat!, long: model.long!)
        : null,
  );
}
