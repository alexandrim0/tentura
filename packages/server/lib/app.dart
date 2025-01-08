import 'dart:io';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'consts.dart';
import 'di/di.dart';
import 'di/modules.dart';
import 'route_handler.dart';

Future<void> runApp() async {
  const port = int.fromEnvironment(
    'PORT',
    defaultValue: 2080,
  );

  await configureDependencies(Environment.prod);

  final logger = GetIt.I<Logger>();
  await logger.init;

  final server = await shelfRun(
    routeHandler,
    defaultShared: true,
    defaultBindPort: port,
    defaultBindAddress: '0.0.0.0',
    defaultEnableHotReload: kDebugMode,
    onStarted: (address, port) => logger.w(
      'Start serving at ${DateTime.timestamp()} on http://$address:$port',
      time: DateTime.timestamp(),
    ),
    onStartFailed: (e) async {
      logger.e(
        'Failed to start:',
        error: e,
      );
      await closeModules();
    },
    onClosed: () async {
      logger.w(
        'Stop serving at ${DateTime.timestamp()}.',
      );
      await closeModules();
    },
  );

  await Future.any([
    ProcessSignal.sigint.watch().first,
    ProcessSignal.sigterm.watch().first,
  ]).then((_) async {
    await server.close();
    await GetIt.I.reset();
    exit(0);
  });
}
