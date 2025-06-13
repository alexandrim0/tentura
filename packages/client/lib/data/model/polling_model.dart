import 'package:tentura/domain/entity/polling.dart';
import 'package:tentura/domain/entity/profile.dart';

import '../gql/_g/polling_model.data.gql.dart';

extension type const PollingModel(GPollingModel i) implements GPollingModel {
  Polling toEntity({required Profile author}) => Polling(
    id: i.id,
    author: author,
    question: i.question,
    isEnabled: i.enabled,
    createdAt: i.created_at,
    updatedAt: i.updated_at,
    variants: {
      for (final e in i.variants) e.id: e.description,
    },
  );
}
