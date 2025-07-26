import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/invitation_entity.dart';

import '../invitation_repository.dart';

@Injectable(
  as: InvitationRepository,
  env: [Environment.test],
  order: 1,
)
class InvitationRepositoryMock implements InvitationRepository {
  @override
  Future<bool> deleteById({
    required String invitationId,
    required String userId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<InvitationEntity?> getById({
    required String invitationId,
    required String userId,
  }) {
    throw UnimplementedError();
  }
}
