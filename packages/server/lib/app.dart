import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:jaspr/server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'env.dart';
import 'di/di.dart';
import 'jaspr_options.dart';
import 'api/route_handler.dart';

class App {
  const App();

  Future<void> run([Env? env]) async {
    env ??= Env.fromSystem()..printEnvInfo();

    print(
      'Start serving at ${DateTime.timestamp()} '
      '[${env.bindAddress}:${env.listenPort}]',
    );

    final isolates = [
      for (var i = 1; i < env.isolatesCount; i += 1)
        await Isolate.spawn(
          serve,
          env,
          errorsAreFatal: false,
          debugName: 'Worker #$i',
        ),
    ];

    await serve(env);

    for (final isolate in isolates) {
      isolate.kill();
    }

    print('Stop serving at ${DateTime.timestamp()}.');
  }

  static Future<void> serve(Env env) async {
    Jaspr.initializeApp(options: defaultJasprOptions);
    final getIt = await configureDependencies(env.environment);
    final server = await shelfRun(
      routeHandler,
      defaultShared: true,
      defaultBindPort: env.listenPort,
      defaultBindAddress: env.bindAddress,
      defaultEnableHotReload: env.isDebugModeOn,
    );

    await Future.any([
      ProcessSignal.sigint.watch().first,
      ProcessSignal.sigterm.watch().first,
    ]);

    await server.close();
    await getIt.reset();
  }
}
