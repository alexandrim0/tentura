import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import 'package:tentura_server/domain/entity/fcm_token_entity.dart';

import '../database/tentura_db.dart';

@Injectable(
  env: [
    Environment.dev,
    Environment.prod,
  ],
  order: 1,
)
class FcmTokenRepository {
  const FcmTokenRepository(this._database);

  final TenturaDb _database;

  ///
  Future<Iterable<FcmTokenEntity>> getTokensByUserId() async => [];

  ///
  /// Insert token into DB, ignore if exists
  ///
  Future<void> putToken({
    required String userId,
    required String appId,
    required String token,
    required String platform,
  }) => _database.managers.fcmTokens.create(
    (o) => o(
      userId: userId,
      appId: UuidValue.fromString(appId),
      token: token,
      platform: platform,
    ),
    mode: InsertMode.insertOrIgnore,
  );
}
