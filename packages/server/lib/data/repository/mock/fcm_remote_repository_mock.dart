import 'package:injectable/injectable.dart';

import '../fcm_remote_repository.dart';

@Singleton(
  env: [Environment.test],
  order: 1,
)
class FcmRemoteRepositoryMock implements FcmRemoteRepository {
  @override
  Future<void> sendFcmMessage({
    required String fcmToken,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> sendFcmMessages({
    required Iterable<String> fcmTokens,
    required String title,
    required String body,
  }) async {}
}
