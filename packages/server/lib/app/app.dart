import 'dart:io';
import 'dart:async';

import '../env.dart';
import 'worker.dart';

class App {
  const App();

  Future<void> run(Env env) async {
    env.printEnvInfo();

    final workers = await Future.wait([
      for (var i = 0; i < env.isolatesCount; i += 1)
        Worker.spawn(env: env, debugName: 'Worker #$i'),
    ]);

    await Future.any([
      ProcessSignal.sigint.watch().first,
      ProcessSignal.sigterm.watch().first,
    ]);

    await Future.wait(workers.map((e) => e.close()));
  }
}
