import 'package:tentura_server/domain/entity/user_presence_entity.dart';

import '../database/tentura_db.dart';

UserPresenceEntity userPresenceModelToEntity(UserPresenceData model) =>
    UserPresenceEntity(
      userId: model.userId,
      status: model.status,
      lastSeenAt: model.lastSeenAt.dateTime,
    );
