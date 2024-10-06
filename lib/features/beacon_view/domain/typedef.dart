import 'package:tentura/features/beacon/domain/entity/beacon.dart';
import 'package:tentura/features/comment/domain/entity/comment.dart';

typedef BeaconViewResult = ({Beacon beacon, Comment comment});

typedef BeaconViewResults = ({Beacon beacon, Iterable<Comment> comments});
