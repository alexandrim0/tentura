import 'dart:io';
import 'dart:async';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/database/migration/_migrations.dart';

import 'worker.dart';

class App {
  const App();

  Future<void> run([Env? env]) async {
    env ??= Env.prod();

    await migrateDbSchema(env);

    final workers = await Future.wait([
      for (var i = 0; i < env.isolatesCount; i += 1)
        Worker.spawn(env: env, debugName: 'Worker #$i'),
    ]);

    await _stopSignal();

    await Future.wait(workers.map((e) => e.close()));
  }

  Future<void> runTest([Env? env]) async {
    env ??= Env.test();

    final worker = await Worker.spawn(env: env, debugName: 'Worker #Test');

    await _stopSignal();

    await worker.close();
  }

  Future<void> _stopSignal() => Future.any([
    ProcessSignal.sigint.watch().first,
    ProcessSignal.sigterm.watch().first,
  ]);
}
