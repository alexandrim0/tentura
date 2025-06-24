import 'package:migrant/migrant.dart';
import 'package:migrant/testing.dart';
import 'package:postgres/postgres.dart';
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';

part 'm0001.dart';
part 'm0002.dart';
part 'm0003.dart';
part 'm0004.dart';
part 'm0005.dart';

Future<void> migrateDbSchema(Connection connection) =>
    Database(PostgreSQLGateway(connection)).upgrade(
      InMemory([
        m0001,
        m0002,
        m0003,
        m0004,
        m0005,
      ]),
    );
