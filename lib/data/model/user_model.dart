import '../../data/gql/_g/user_model.data.gql.dart';
import '../../domain/entity/profile.dart';

extension type const UserModel(GUserModel i) implements GUserModel {
  Profile get toEntity => Profile(
        id: i.id,
        title: i.title,
        description: i.description,
        hasAvatar: i.has_picture,
        myVote: i.my_vote ?? 0,
        score: double.tryParse(i.scores?.first.dst_score?.value ?? '') ?? 0,
        rScore: double.tryParse(i.scores?.first.src_score?.value ?? '') ?? 0,
      );
}
