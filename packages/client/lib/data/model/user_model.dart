import '../../data/gql/_g/user_model.data.gql.dart';
import '../../domain/entity/profile.dart';

extension type const UserModel(GUserModel i) implements GUserModel {
  Profile get toEntity => Profile(
        id: i.id,
        title: i.title,
        blurhash: i.blur_hash,
        hasAvatar: i.has_picture,
        description: i.description,
        imageHeight: i.pic_height,
        imageWidth: i.pic_width,
        myVote: i.my_vote ?? 0,
        score: double.tryParse(i.scores?.first.dst_score?.value ?? '') ?? 0,
        rScore: double.tryParse(i.scores?.first.src_score?.value ?? '') ?? 0,
      );
}
