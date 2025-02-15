import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:shelf_plus/shelf_plus.dart';

import 'consts.dart';
import 'di/di.dart';
import 'domain/enum.dart';
import 'api/route_handler.dart';

export 'domain/enum.dart';

class App {
  App({this.env = Environment.prod, int? numberOfIsolates})
    : _numberOfIsolates = numberOfIsolates ?? kWorkersCount;

  final Environment env;

  final int _numberOfIsolates;

  Future<void> run() async {
    log(
      'Start serving at ${DateTime.timestamp()} [$kBindAddress:$kListenPort]',
    );

    final children = [
      for (var i = 1; i < _numberOfIsolates; i += 1)
        await Isolate.spawn(_serve, this),
    ];

    await _serve(this);

    for (final isolate in children) {
      isolate.kill();
    }

    log('Stop serving at ${DateTime.timestamp()}.');
    exit(0);
  }
}

Future<void> _serve(App app) async {
  configureDependencies(app.env);

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
  await server.close();
  await closeModules();
}
