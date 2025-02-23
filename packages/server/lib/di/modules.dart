import 'package:minio/minio.dart';
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

  Minio get minio => Minio(
    accessKey: kS3AccessKey,
    secretKey: kS3SecretKey,
    endPoint: kS3Endpoint,
    pathStyle: false,
  );
}
