import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/invitation_entity.dart';

import '../database/tentura_db.dart';
import '../mapper/invitation_mapper.dart';
import '../mapper/user_mapper.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class InvitationRepository with UserMapper, InvitationMapper {
  const InvitationRepository(this._database);

  final TenturaDb _database;

  Future<InvitationEntity> getById(String id) async {
    final (invitation, refs) =
        await _database.managers.invitations
            .filter((f) => f.id(id))
            .withReferences((p) => p(userId: true, invitedId: true))
            .getSingle();
    return invitationModelToEntity(
      invitation,
      issuer: await refs.userId.getSingle(),
      invited: await refs.invitedId?.getSingleOrNull(),
    );
  }

  Future<bool> deleteById({
    required String invitationId,
    required String userId,
  }) async =>
      await _database.managers.invitations
          .filter((e) => e.id(invitationId) & e.userId.id(userId))
          .delete() ==
      1;
}
