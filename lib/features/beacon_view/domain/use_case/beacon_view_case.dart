import 'package:injectable/injectable.dart';

import 'package:tentura/features/comment/data/comment_repository.dart';
import 'package:tentura/features/comment/domain/entity/comment.dart';

import '../../data/repository/beacon_view_repository.dart';
import '../typedef.dart';

@lazySingleton
class BeaconViewCase {
  const BeaconViewCase(
    this._beaconViewRepository,
    this._commentRepository,
  );

  final CommentRepository _commentRepository;
  final BeaconViewRemoteRepository _beaconViewRepository;

  Future<BeaconViewResult> fetchBeaconByCommentId(String commentId) =>
      _beaconViewRepository.fetchBeaconByCommentId(commentId);

  Future<BeaconViewResults> fetchBeaconByIdWithComments({
    required String beaconId,
    int limit = 3,
  }) =>
      _beaconViewRepository.fetchBeaconByIdWithComments(
        beaconId: beaconId,
        limit: limit,
      );

  Future<Iterable<Comment>> fetchCommentsByBeaconId(String beaconId) =>
      _commentRepository.fetchCommentsByBeaconId(beaconId);

  Future<Comment> addComment({
    required String beaconId,
    required String content,
  }) =>
      _commentRepository.addComment(
        beaconId: beaconId,
        content: content,
      );
}
