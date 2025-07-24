import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/remote_api_service.dart';

@singleton
class AuthRemoteRepository {
  AuthRemoteRepository(
    this._remoteApiService,
  );

  // ignore: unused_field // TBD:
  final RemoteApiService _remoteApiService;
}
