import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/remote_api_service.dart';

import '../../domain/exception.dart';
import '../../domain/typedef.dart';
import '../gql/_g/like_beacon_by_id.req.gql.dart';
import '../gql/_g/like_comment_by_id.req.gql.dart';
import '../gql/_g/like_user_by_id.req.gql.dart';

@lazySingleton
class LikeRemoteRepository {
  static const _label = 'Like';

  LikeRemoteRepository(this._remoteApiService);

  final RemoteApiService _remoteApiService;

  final _controller = StreamController<LikeAmount>.broadcast();

  Stream<LikeAmount> get changes => _controller.stream;

  @disposeMethod
  Future<void> dispose() => _controller.close();

  Future<int> likeBeacon({
    required String beaconId,
    required int amount,
  }) async {
    final response = await _remoteApiService
        .request(GLikeBeaconByIdReq(
          (b) => b
            ..vars.amount = amount
            ..vars.beacon_id = beaconId,
        ))
        .firstWhere((e) => e.dataSource == DataSource.Link);
    final result =
        response.dataOrThrow(label: _label).insert_vote_beacon_one?.amount;
    if (result == null) throw LikeSetException(beaconId);
    _controller.add((id: beaconId, amount: result));
    return result;
  }

  Future<int> likeComment({
    required String commentId,
    required int amount,
  }) async {
    final response = await _remoteApiService
        .request(GLikeCommentByIdReq(
          (b) => b
            ..vars.amount = amount
            ..vars.comment_id = commentId,
        ))
        .firstWhere((e) => e.dataSource == DataSource.Link);
    final result =
        response.dataOrThrow(label: _label).insert_vote_comment_one?.amount;
    if (result == null) throw LikeSetException(commentId);
    _controller.add((id: commentId, amount: result));
    return result;
  }

  Future<int> likeUser({
    required String userId,
    required int amount,
  }) async {
    final response = await _remoteApiService
        .request(GLikeUserByIdReq(
          (b) => b.vars
            ..object = userId
            ..amount = amount,
        ))
        .firstWhere((e) => e.dataSource == DataSource.Link);
    final result =
        response.dataOrThrow(label: _label).insert_vote_user_one?.amount;
    if (result == null) throw LikeSetException(userId);
    _controller.add((id: userId, amount: result));
    return result;
  }
}
