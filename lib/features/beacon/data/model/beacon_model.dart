import 'package:tentura/features/geo/domain/entity/coordinates.dart';
import 'package:tentura/features/profile/data/model/user_model.dart';

import '../../domain/entity/beacon.dart';
import '../gql/_g/beacon_model.data.gql.dart';

extension type const BeaconModel(GBeaconModel i) implements GBeaconModel {
  Beacon get toEntity => Beacon(
        id: i.id,
        title: i.title,
        isEnabled: i.enabled,
        dateRange: i.timerange,
        createdAt: i.created_at,
        updatedAt: i.updated_at,
        hasPicture: i.has_picture,
        description: i.description,
        isPinned: i.is_pinned ?? false,
        context: i.context ?? '',
        myVote: i.my_vote ?? 0,
        coordinates: i.lat == null || i.long == null
            ? Coordinates.zero
            : Coordinates(
                lat: double.tryParse(i.lat?.value ?? '') ?? 0,
                long: double.tryParse(i.long?.value ?? '') ?? 0,
              ),
        score: double.tryParse(i.scores?.first.dst_score?.value ?? '') ?? 0,
        author: (i.author as UserModel).toEntity,
      );
}
