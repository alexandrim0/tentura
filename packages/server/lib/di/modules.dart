import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import '../consts.dart';

@module
abstract class RegisterModule {
  @singleton
  Logger get logger => kDebugMode
      ? Logger()
      : Logger(
          filter: ProductionFilter(),
          level: Level.warning,
        );

  @singleton
  Database get database => Database(
        username: kPgUsername,
        password: kPgPassword,
        database: kPgDatabase,
        port: kPgPort,
        host: kPgHost,
        useSSL: false,
        isUnixSocket: false,
      );
}

Future<void> closeModules() async {
  await GetIt.I<Database>().close();
  await GetIt.I<Logger>().close();
}
