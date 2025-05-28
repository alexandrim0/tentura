import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:jaspr/server.dart' hide kDebugMode;
import 'package:shelf_plus/shelf_plus.dart';

import 'domain/use_case/task_worker_case.dart';
import 'env.dart';
import 'di/di.dart';
import 'consts.dart';
import 'jaspr_options.dart';
import 'api/route_handler.dart';
import 'domain/enum.dart';

class App {
  App({this.env = Environment.prod, int? numberOfIsolates})
    : _numberOfIsolates = numberOfIsolates ?? kWorkersCount;

  final Environment env;

  final int _numberOfIsolates;

  Future<void> run() async {
    print(
      'Start serving at ${DateTime.timestamp()} [$kBindAddress:$kListenPort]',
    );

    if (kDebugMode) {
      await _serve(this, isMainIsolate: true);
    } else {
      final children = [
        for (var i = 1; i < _numberOfIsolates; i += 1)
          await Isolate.spawn(
            _serve,
            this,
            errorsAreFatal: false,
            debugName: 'Worker #$i',
          ),
      ];

      await _serve(this, isMainIsolate: true);

      for (final isolate in children) {
        isolate.kill();
      }
    }

    print('Stop serving at ${DateTime.timestamp()}.');
    exit(0);
  }

  static Future<void> _serve(App app, {bool isMainIsolate = false}) async {
    Jaspr.initializeApp(options: defaultJasprOptions);
    final getIt = await configureDependencies(app.env);
    if (isMainIsolate) {
      getIt<Env>().printEnvInfo();
      unawaited(getIt<TaskWorkerCase>().run());
    }

    final server = await shelfRun(
      routeHandler,
      defaultShared: true,
      defaultBindPort: kListenPort,
      defaultBindAddress: kBindAddress,
      defaultEnableHotReload: kDebugMode,
    );

    await Future.any([
      ProcessSignal.sigint.watch().first,
      ProcessSignal.sigterm.watch().first,
    ]);
    if (isMainIsolate) {
      unawaited(getIt<TaskWorkerCase>().dispose());
    }
    await server.close();
    await getIt.reset();
  }
}
