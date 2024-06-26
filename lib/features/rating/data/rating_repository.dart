import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/user.dart';

import '../domain/entity/user_rating.dart';
import 'gql/_g/fetch_users_rating.req.gql.dart';

class RatingRepository {
  static const _label = 'Rating';

  RatingRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  late final _fetchRequest =
      GUsersRatingReq((r) => r.fetchPolicy = FetchPolicy.CacheAndNetwork);

  Stream<Iterable<UserRating>> get stream =>
      _remoteApiService.gqlClient.request(_fetchRequest).map((r) => r
          .dataOrThrow(label: _label)
          .usersStats
          .where(
              (e) => e.user != null && e.user!.id != _remoteApiService.userId)
          .map((e) => UserRating(
                egoScore: e.egoScore,
                userScore: e.nodeScore,
                user: e.user! as User,
              )));

  Future<void> fetch() =>
      _remoteApiService.gqlClient.addRequestToRequestController(_fetchRequest);
}
