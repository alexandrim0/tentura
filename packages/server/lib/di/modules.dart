import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import '../consts.dart';

@module
abstract class RegisterModule {
  @singleton
  Logger get logger => Logger();

  @singleton
  Database get database => Database(
        username: kPgUsername,
        password: kPgPassword,
        database: kPgDatabase,
        port: kPgPort,
        host: kPgHost,
        useSSL: false,
      );
}
