import 'package:drift/drift.dart';
import 'package:postgres/postgres.dart';
import 'package:injectable/injectable.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';
import 'package:tentura_server/domain/entity/invitation_entity.dart';
import 'package:tentura_server/domain/entity/opinion_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';

import 'table/beacons.dart';
import 'table/comments.dart';
import 'table/invitations.dart';
import 'table/opinions.dart';
import 'table/users.dart';
import 'table/vote_users.dart';

export 'package:drift/drift.dart';

part 'tentura_db.g.dart';

@singleton
@DriftDatabase(
  tables: [Beacons, Comments, Invitations, Opinions, Users, VoteUsers],
)
class TenturaDb extends _$TenturaDb {
  @factoryMethod
  TenturaDb()
    : super(
        PgDatabase.opened(
          Pool<dynamic>.withEndpoints(
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
              maxConnectionAge: Duration(seconds: kMaxConnectionAge),
              maxConnectionCount: kMaxConnectionCount,
              sslMode: SslMode.disable,
            ),
          ),
          enableMigrations: false,
          logStatements: kDebugMode,
        ),
      );

  TenturaDb.forTest({required PgDatabase database}) : super(database);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );
}
