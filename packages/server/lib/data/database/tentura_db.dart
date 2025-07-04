import 'package:drift/drift.dart';
import 'package:postgres/postgres.dart';
import 'package:injectable/injectable.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';
import 'package:tentura_server/domain/entity/invitation_entity.dart';
import 'package:tentura_server/domain/entity/opinion_entity.dart';
import 'package:tentura_server/domain/entity/polling_entity.dart';
import 'package:tentura_server/domain/entity/polling_variant_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/env.dart';

import 'table/beacons.dart';
import 'table/comments.dart';
import 'table/images.dart';
import 'table/invitations.dart';
import 'table/messages.dart';
import 'table/opinions.dart';
import 'table/pollings.dart';
import 'table/polling_acts.dart';
import 'table/polling_variants.dart';
import 'table/users.dart';
import 'table/vote_users.dart';

export 'package:drift/drift.dart';

part 'tentura_db.g.dart';

@singleton
@DriftDatabase(
  tables: [
    Beacons,
    Comments,
    Images,
    Invitations,
    Messages,
    Opinions,
    Users,
    VoteUsers,
    Pollings,
    PollingVariants,
    PollingActs,
  ],
)
class TenturaDb extends _$TenturaDb {
  @factoryMethod
  TenturaDb(Env env)
    : super(
        PgDatabase.opened(
          Pool<dynamic>.withEndpoints([
            env.pgEndpoint,
          ], settings: env.pgPoolSettings),
          enableMigrations: false,
          logStatements: env.isDebugModeOn,
        ),
      );

  TenturaDb.forTest({required PgDatabase database}) : super(database);

  @override
  int get schemaVersion => 1;

  @disposeMethod
  Future<void> dispose() => super.close();
}
