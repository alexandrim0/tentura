import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import '../consts.dart';

@module
abstract class RegisterModule {
  Database get database => Database.withPool(
    debugPrint: kDebugMode,
    pool: Pool.withEndpoints(
      [
        Endpoint(
          host: kPgHost,
          port: kPgPort,
          database: kPgDatabase,
          username: kPgUsername,
          password: kPgPassword,
        ),
      ],
      settings: PoolSettings(
        maxConnectionCount: kMaxConnectionCount,
        sslMode: SslMode.disable,
      ),
    ),
  );
}
