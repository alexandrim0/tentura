import 'dart:async';
import 'dart:isolate';
import 'package:jaspr/server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../env.dart';
import 'di.dart';
import '../jaspr_options.dart';
import '../api/route_handler.dart';

class Worker {
  Worker._(this._isolate, this._responses, this._commands);

  final ReceivePort _responses;

  final SendPort _commands;

  final Isolate _isolate;

  Future<void> close() async {
    _commands.send(null);
    await _responses.first.timeout(
      const Duration(seconds: 10),
      onTimeout: () => print('Timeout on close isolate'),
    );
    _responses.close();
    _isolate.kill();
  }

  static Future<Worker> spawn({required Env env, String debugName = ''}) async {
    final initPort = RawReceivePort(null, debugName);
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (dynamic commandPort) {
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort as SendPort,
      ));
    };

    try {
      final isolate = await Isolate.spawn(
        _serve,
        (sendPort: initPort.sendPort, env: env),
        debugName: debugName,
        errorsAreFatal: false,
      );
      final (ReceivePort receivePort, SendPort sendPort) =
          await connection.future;
      return Worker._(isolate, receivePort, sendPort);
    } catch (e) {
      print(e);
      initPort.close();
      rethrow;
    }
  }

  static Future<void> _serve(({SendPort sendPort, Env env}) params) async {
    final receivePort = ReceivePort();
    params.sendPort.send(receivePort.sendPort);

    Jaspr.initializeApp(options: defaultJasprOptions);
    final getIt = await configureDependencies(params.env);
    final server = await shelfRun(
      getIt<RootRouter>().routeHandler,
      defaultEnableHotReload: params.env.isDebugModeOn,
      defaultBindAddress: params.env.bindAddress,
      defaultBindPort: params.env.listenPort,
      defaultShared: true,
    );
    print('${Isolate.current.debugName} started at ${DateTime.timestamp()}');

    await receivePort.first;
    receivePort.close();
    await server.close();
    await getIt.reset();
    params.sendPort.send(null);
    print('${Isolate.current.debugName} stoped at ${DateTime.timestamp()}');
  }
}
