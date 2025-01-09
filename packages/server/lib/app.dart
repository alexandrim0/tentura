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

Future<void> runApp({
  Future<void> Function()? beforeStart,
  String? env,
}) async {
  await configureDependencies(env ?? Environment.prod);

  final logger = GetIt.I<Logger>();
  await logger.init;
  await beforeStart?.call();

  final server = await shelfRun(
    routeHandler,
    defaultShared: true,
    defaultBindPort: kListenPort,
    defaultBindAddress: kBindAddress,
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
