import 'package:flutter/foundation.dart';
import 'package:force_directed_graphview/force_directed_graphview.dart'
    show NodeBase;

@immutable
sealed class NodeDetails extends NodeBase {
  const NodeDetails({
    required this.id,
    this.hasImage = false,
    this.label = '',
    this.score = 0,
    super.size = 40,
    super.pinned,
  });

  final String id;
  final String label;
  final double score;
  final bool hasImage;

  String get userId;

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      score.hashCode ^
      userId.hashCode ^
      hasImage.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeDetails &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          score == other.score &&
          userId == other.userId &&
          hasImage == other.hasImage;
}

final class UserNode extends NodeDetails {
  const UserNode({
    required super.id,
    super.score,
    super.label,
    super.size,
    super.pinned,
    super.hasImage,
  });

  @override
  String get userId => id;

  @override
  UserNode copyWithPinned(bool pinned) => UserNode(
        id: id,
        size: size,
        label: label,
        hasImage: hasImage,
        pinned: pinned,
        score: score,
      );
}

final class BeaconNode extends NodeDetails {
  const BeaconNode({
    required this.userId,
    required super.id,
    super.score,
    super.label,
    super.size,
    super.pinned,
    super.hasImage,
  });

  @override
  final String userId;

  @override
  BeaconNode copyWithPinned(bool pinned) => BeaconNode(
        id: id,
        size: size,
        label: label,
        userId: userId,
        hasImage: hasImage,
        pinned: pinned,
        score: score,
      );
}
