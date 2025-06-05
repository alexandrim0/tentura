import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/mapper/task_status_mapper.dart';
import 'package:tentura_server/domain/entity/task_entity.dart';

import '../service/task_worker.dart';

@LazySingleton(env: [Environment.dev, Environment.prod])
class TasksRepository with TaskStatusMapper {
  @FactoryMethod()
  static Future<TasksRepository> create(TaskWorker taskWorker) async =>
      TasksRepository(taskWorker);

  const TasksRepository(this._taskWorker);

  final TaskWorker _taskWorker;

  Future<T?> acquire<T extends TaskEntity>() async {
    switch (T) {
      case const (TaskProfileImageHash):
        final task = await _taskWorker.acquire(queue: _queueProfileImageHash);
        return task == null
            ? null
            : TaskProfileImageHash(
                    id: task.id,
                    status: taskStatusFromJobStatus(task.status),
                    details: TaskProfileImageHashDetails.fromJson(task.payload),
                  )
                  as T;

      case const (TaskBeaconImageHash):
        final task = await _taskWorker.acquire(queue: _queueBeaconImageHash);
        return task == null
            ? null
            : TaskBeaconImageHash(
                    id: task.id,
                    status: taskStatusFromJobStatus(task.status),
                    details: TaskBeaconImageHashDetails.fromJson(task.payload),
                  )
                  as T;
    }
    return null;
  }

  Future<String> schedule(TaskEntity task) => switch (task) {
    TaskProfileImageHash() => _taskWorker.schedule(
      task.details.toJson(),
      queue: _queueProfileImageHash,
    ),
    TaskBeaconImageHash() => _taskWorker.schedule(
      task.details.toJson(),
      queue: _queueBeaconImageHash,
    ),
  };

  Future<void> complete(String id) => _taskWorker.complete(id);

  Future<void> fail(String id) => _taskWorker.fail(id);

  static const _queueProfileImageHash = 'profile_image_hash';
  static const _queueBeaconImageHash = 'beacon_image_hash';
}
