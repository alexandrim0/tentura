import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/data/repository/tasks_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/env.dart';

import '../entity/task_entity.dart';
import 'image_case_mixin.dart';

@Singleton(env: [Environment.dev, Environment.prod], order: 2)
class TaskWorkerCase with ImageCaseMixin {
  TaskWorkerCase(
    this._env,
    this._beaconRepository,
    this._imageRepository,
    this._tasksRepository,
    this._userRepository,
  );

  final Env _env;

  final BeaconRepository _beaconRepository;

  final ImageRepository _imageRepository;

  final TasksRepository _tasksRepository;

  final UserRepository _userRepository;

  final _runnerCompleter = Completer<void>();

  late final _tasks = <Future<void> Function()>[
    // Calculate Profile Image Hash
    () async {
      final task = await _tasksRepository.acquire<TaskProfileImageHash>();
      if (task == null) return;
      try {
        final imageBytes = await _imageRepository.getUserImage(
          userId: task.details.userId,
        );
        final image = decodeImage(imageBytes);
        await _userRepository.update(
          id: task.details.userId,
          blurHash: calculateBlurHash(image),
          imageHeight: image.height,
          imageWidth: image.width,
        );
        await _tasksRepository.complete(task.id);
      } catch (e) {
        await _tasksRepository.fail(task.id);
        rethrow;
      }
    },

    // Calculate Beacon Image Hash
    () async {
      final task = await _tasksRepository.acquire<TaskBeaconImageHash>();
      if (task == null) return;
      try {
        final imageBytes = await _imageRepository.getBeaconImage(
          authorId: task.details.userId,
          beaconId: task.details.beaconId,
        );
        final image = decodeImage(imageBytes);
        await _beaconRepository.updateBeaconImageDetails(
          beaconId: task.details.beaconId,
          blurHash: calculateBlurHash(image),
          imageHeight: image.height,
          imageWidth: image.width,
        );
        await _tasksRepository.complete(task.id);
      } catch (e) {
        await _tasksRepository.fail(task.id);
        rethrow;
      }
    },
  ];

  bool _canRun = true;

  @disposeMethod
  Future<void> dispose() {
    _canRun = false;
    print('Trying to stop Task Worker...');
    return _runnerCompleter.future;
  }

  @PostConstruct()
  Future<void> run() async {
    print('Task Worker starts at ${DateTime.timestamp()}');

    while (_canRun) {
      await Future<void>.delayed(_env.taskOnEmptyDelay);
      for (final e in _tasks) {
        try {
          if (_canRun) await e();
        } catch (e) {
          if (_env.isDebugModeOn) print(e);
        }
      }
    }

    print('Task Worker stops at ${DateTime.timestamp()}');
    _runnerCompleter.complete();
  }
}
