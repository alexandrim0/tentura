import 'package:tentura/features/beacon/domain/entity/beacon.dart';
import 'package:tentura/features/profile/domain/entity/profile.dart';

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
            ? (lat: 0, long: 0)
            : (
                lat: double.tryParse(i.lat?.value ?? '') ?? 0,
                long: double.tryParse(i.long?.value ?? '') ?? 0,
              ),
        author: Profile(
          id: i.author.id,
          title: i.author.title,
          hasAvatar: i.author.has_picture,
          score: double.tryParse(i.author.score?.value ?? '') ?? 0,
        ),
      );
}
