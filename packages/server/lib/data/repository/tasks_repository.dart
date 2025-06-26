import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/mapper/task_status_mapper.dart';
import 'package:tentura_server/domain/entity/task_entity.dart';

import '../service/task_worker.dart';

@LazySingleton()
class TasksRepository with TaskStatusMapper {
  @FactoryMethod()
  static Future<TasksRepository> create(TaskWorker taskWorker) async =>
      TasksRepository(taskWorker);

  const TasksRepository(this._taskWorker);

  final TaskWorker _taskWorker;

  Future<T?> acquire<T extends TaskEntity>() async {
    switch (T) {
      case const (TaskCalculateImageHashDetails):
        final task = await _taskWorker.acquire(queue: _queueCalculateImageHash);
        if (task != null) {
          return TaskEntity(
                id: task.id,
                status: taskStatusFromJobStatus(task.status),
                details: TaskCalculateImageHashDetails.fromJson(
                  task.payload,
                ),
              )
              as T;
        }

      default:
        throw UnimplementedError();
    }
    return null;
  }

  Future<String> schedule(TaskEntity task) => switch (task.details) {
    final TaskCalculateImageHashDetails details => _taskWorker.schedule(
      details.toJson(),
      queue: _queueCalculateImageHash,
    ),
    _ => throw UnimplementedError(),
  };

  Future<void> complete(String id) => _taskWorker.complete(id);

  Future<void> fail(String id) => _taskWorker.fail(id);

  static const _queueCalculateImageHash = 'calculate_image_hash';
}
