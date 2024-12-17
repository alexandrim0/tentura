import 'dart:io';
import 'dart:async';
import 'package:jaspr/server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'routes/_router.dart';
import 'utils/logger.dart';

Future<void> main() async {
  Jaspr.initializeApp();

  final server = await shelfRun(
    routeHandler,
    onStarted: (address, port) => logger.i(
      'Start serving at ${DateTime.timestamp()} on http://$address:$port',
    ),
    onStartFailed: (e) => logger.e(
      'Failed to start:',
      error: e,
    ),
    onClosed: () => logger.i(
      'Stop serving at ${DateTime.timestamp()}.',
    ),
  );

  await Future.any([
    ProcessSignal.sigint.watch().first,
    ProcessSignal.sigterm.watch().first,
  ]).then((_) => server.close());
}
