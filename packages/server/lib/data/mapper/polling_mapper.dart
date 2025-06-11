import 'package:tentura_server/domain/entity/polling_entity.dart';

import '../database/tentura_db.dart';
import 'user_mapper.dart';

mixin PollingMapper on UserMapper {
  PollingEntity pollingModelToEntity(
    Polling model, {
    required User author,
    List<PollingVariant>? variants,
  }) => PollingEntity(
    id: model.id,
    question: model.question,
    isEnabled: model.isEnabled,
    author: userModelToEntity(author),
    createdAt: model.createdAt.dateTime,
    updatedAt: model.updatedAt.dateTime,
    variants: variants?.map((e) => e.description).toList() ?? [],
  );
}
