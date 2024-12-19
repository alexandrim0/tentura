import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:postgres/postgres.dart';
import 'package:injectable/injectable.dart';
import 'package:drift_postgres/drift_postgres.dart';

import '../consts.dart';

@module
abstract class RegisterModule {
  @singleton
  Logger get logger => Logger();

  @singleton
  QueryExecutor get database => PgDatabase(
        endpoint: Endpoint(
          host: kPgHost,
          database: kPgDatabase,
          username: kPgUsername,
          password: kPgPassword,
        ),
      );
}
