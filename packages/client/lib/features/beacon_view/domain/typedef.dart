import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/comment.dart';

typedef BeaconViewResult = ({Beacon beacon, Comment comment});

typedef BeaconViewResults = ({Beacon beacon, Iterable<Comment> comments});
