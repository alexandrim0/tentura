import 'package:migrant/migrant.dart';
import 'package:migrant/testing.dart';
import 'package:postgres/postgres.dart';
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';

import 'package:tentura_server/env.dart';

part 'm0001.dart';
part 'm0002.dart';
part 'm0003.dart';
part 'm0004.dart';

Future<void> migrateDbSchema(Env env) async {
  final connection = await Connection.open(
    env.pgEndpoint,
    settings: env.pgEndpointSettings,
  );
  await Database(
    PostgreSQLGateway(connection),
  ).upgrade(InMemory([m0001, m0002, m0003]));
  await connection.close();
}
