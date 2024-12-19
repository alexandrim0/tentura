import 'dart:io';
import 'dart:async';
import 'package:jaspr/server.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'di/di.dart';
import 'routes/_router.dart';

Future<void> runApp() async {
  await configureDependencies();

  Jaspr.initializeApp();

  final server = await shelfRun(
    routeHandler,
    onStarted: (address, port) => GetIt.I<Logger>().i(
      'Start serving at ${DateTime.timestamp()} on http://$address:$port',
    ),
    onStartFailed: (e) => GetIt.I<Logger>().e(
      'Failed to start:',
      error: e,
    ),
    onClosed: () => GetIt.I<Logger>().i(
      'Stop serving at ${DateTime.timestamp()}.',
    ),
  );

  await Future.any([
    ProcessSignal.sigint.watch().first,
    ProcessSignal.sigterm.watch().first,
  ]).then((_) async {
    await server.close();
    await GetIt.I.reset();
  });
}
