import 'dart:io';
import 'dart:async';
import 'package:injectable/injectable.dart' show Environment;

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/database/migration/_migrations.dart';

import 'worker.dart';

class App {
  const App();

  Future<void> run([Env? env]) async {
    env ??= Env();
    env.printEnvInfo();
    await migrateDbSchema(env);

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

  Future<void> runTest([Env? env]) async {
    env ??= Env(
      environment: Environment.test,
      isDebugModeOn: true,
      workersCount: 1,
    );
    env.printEnvInfo();

    final worker = await Worker.spawn(env: env, debugName: 'Worker #Test');

    await Future.any([
      ProcessSignal.sigint.watch().first,
      ProcessSignal.sigterm.watch().first,
    ]);

    await worker.close();
  }
}
