import 'dart:async';
import 'dart:isolate';
import 'package:jaspr/server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/jaspr_options.dart';
import 'package:tentura_server/api/route_handler.dart';
import 'package:tentura_server/domain/use_case/task_worker_case.dart';

import 'di.dart';

class Worker {
  static Future<Worker> spawnWebWorker({
    required Env env,
    String debugName = 'Web worker',
  }) => _spawn(env: env, debugName: debugName, worker: _serveWeb);

  static Future<Worker> spawnTaskWorker({
    required Env env,
    String debugName = 'Task worker',
  }) => _spawn(env: env, debugName: debugName, worker: _serveTask);

  Worker._(this._isolate, this._responses, this._commands);

  final ReceivePort _responses;

  final SendPort _commands;

  final Isolate _isolate;

  Future<void> close() async {
    _commands.send(null);
    await _responses.first.timeout(
      const Duration(seconds: 10),
      onTimeout: () =>
          print('Timeout on close isolate [${Isolate.current.debugName}]'),
    );
    _responses.close();
    _isolate.kill();
  }

  static Future<Worker> _spawn({
    required Env env,
    required String debugName,
    required Future<void> Function(({SendPort sendPort, Env env})) worker,
  }) async {
    final initPort = RawReceivePort(null, debugName);
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (dynamic commandPort) {
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort as SendPort,
      ));
    };

    try {
      final isolate = await Isolate.spawn(
        worker,
        (sendPort: initPort.sendPort, env: env),
        debugName: debugName,
        errorsAreFatal: false,
      );
      final (ReceivePort receivePort, SendPort sendPort) =
          await connection.future;
      return Worker._(isolate, receivePort, sendPort);
    } catch (e) {
      print(e);
      initPort.close();
      rethrow;
    }
  }

  //
  static Future<void> _serveTask(({SendPort sendPort, Env env}) params) async {
    final receivePort = ReceivePort();
    params.sendPort.send(receivePort.sendPort);

    final getIt = await configureDependencies(params.env);
    final taskWorker = await getIt.getAsync<TaskWorkerCase>();
    unawaited(taskWorker.run());
    print('${Isolate.current.debugName} started at ${DateTime.timestamp()}');

    await receivePort.first;
    receivePort.close();
    await taskWorker.dispose();
    await getIt.reset();
    params.sendPort.send(null);
    print('${Isolate.current.debugName} stoped at ${DateTime.timestamp()}');
  }

  //
  static Future<void> _serveWeb(({SendPort sendPort, Env env}) params) async {
    final receivePort = ReceivePort();
    params.sendPort.send(receivePort.sendPort);

    Jaspr.initializeApp(options: defaultJasprOptions);
    final getIt = await configureDependencies(params.env);
    await getIt.allReady();
    final webServer = await shelfRun(
      getIt<RootRouter>().routeHandler,
      onStarted: (address, port) => print(
        '${Isolate.current.debugName} '
        'started at ${DateTime.timestamp()} '
        'on [$address:$port]',
      ),
      defaultEnableHotReload: params.env.isDebugModeOn,
      defaultBindAddress: params.env.bindAddress,
      defaultBindPort: params.env.listenPort,
      defaultShared: true,
    );

    await receivePort.first;
    receivePort.close();
    await webServer.close();
    await getIt.reset();
    params.sendPort.send(null);
    print('${Isolate.current.debugName} stoped at ${DateTime.timestamp()}');
  }
}
