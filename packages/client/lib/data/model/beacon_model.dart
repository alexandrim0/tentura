import '../../domain/entity/beacon.dart';
import '../../domain/entity/coordinates.dart';
import '../gql/_g/beacon_model.data.gql.dart';
import 'user_model.dart';

extension type const BeaconModel(GBeaconModel i) implements GBeaconModel {
  Beacon get toEntity => Beacon(
        id: i.id,
        title: i.title,
        isEnabled: i.enabled,
        dateRange: i.timerange,
        createdAt: i.created_at,
        updatedAt: i.updated_at,
        hasPicture: i.has_picture,
        imageHeight: i.pic_height,
        imageWidth: i.pic_width,
        blurhash: i.blur_hash,
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
        rScore: double.tryParse(i.scores?.first.src_score?.value ?? '') ?? 0,
        score: double.tryParse(i.scores?.first.dst_score?.value ?? '') ?? 0,
        author: (i.author as UserModel).toEntity,
      );
}
