import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';
part 'task_entity.g.dart';

enum TaskStatus { scheduled, acquired, completed, failed }

sealed class TaskEntity {
  const TaskEntity({this.id = '', this.status = TaskStatus.scheduled});

  final String id;

  final TaskStatus status;
}

class TaskProfileImageHash extends TaskEntity {
  const TaskProfileImageHash({required this.details, super.id, super.status});

  final TaskProfileImageHashDetails details;
}

class TaskBeaconImageHash extends TaskEntity {
  const TaskBeaconImageHash({required this.details, super.id, super.status});

  final TaskBeaconImageHashDetails details;
}

@freezed
abstract class TaskProfileImageHashDetails with _$TaskProfileImageHashDetails {
  const factory TaskProfileImageHashDetails({required String userId}) =
      _TaskProfileImageHashDetails;

  const TaskProfileImageHashDetails._();

  factory TaskProfileImageHashDetails.fromJson(Map<String, dynamic> json) =>
      _$TaskProfileImageHashDetailsFromJson(json);
}

@freezed
abstract class TaskBeaconImageHashDetails with _$TaskBeaconImageHashDetails {
  const factory TaskBeaconImageHashDetails({
    required String beaconId,
    required String userId,
  }) = _TaskBeaconImageHashDetails;

  const TaskBeaconImageHashDetails._();

  factory TaskBeaconImageHashDetails.fromJson(Map<String, dynamic> json) =>
      _$TaskBeaconImageHashDetailsFromJson(json);
}
