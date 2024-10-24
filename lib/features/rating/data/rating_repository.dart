import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/remote_api_service.dart';

import 'package:tentura/features/profile/domain/entity/profile.dart';

import '../domain/entity/user_rating.dart';
import 'gql/_g/rating_fetch.req.gql.dart';

@lazySingleton
class RatingRepository {
  static const _label = 'Rating';

  RatingRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  Future<Iterable<UserRating>> fetch({required String context}) =>
      _remoteApiService
          .request(GRatingFetchReq((r) => r.vars.context = context))
          .firstWhere((e) => e.dataSource == DataSource.Link)
          .then((r) => r.dataOrThrow(label: _label).rating)
          .then(
            (r) => r.map((e) => UserRating(
                  egoScore: double.parse(e.src_score!.value),
                  userScore: double.parse(e.dst_score!.value),
                  profile: Profile(
                    id: e.user?.id ?? '',
                    title: e.user?.title ?? '',
                    myVote: e.user?.my_vote ?? 0,
                    hasAvatar: e.user?.has_picture ?? false,
                    score: double.tryParse(e.user?.score?.value ?? '') ?? 0,
                  ),
                )),
          );
}
