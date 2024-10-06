import 'package:tentura/features/profile/domain/entity/profile.dart';

import '../gql/_g/user_model.data.gql.dart';

extension type const UserModel(GUserModel i) implements GUserModel {
  Profile get toEntity => Profile(
        id: i.id,
        title: i.title,
        description: i.description,
        hasAvatar: i.has_picture,
        myVote: i.my_vote ?? 0,
        score: double.tryParse(i.score?.value ?? '') ?? 0,
      );
}
