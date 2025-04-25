import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/invitation_model.dart';
import 'package:tentura_server/domain/entity/invitation_entity.dart';
import 'package:tentura_server/domain/exception.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class InvitationRepository {
  const InvitationRepository(this._database);

  final Database _database;

  Future<InvitationEntity> getById(String id) async {
    final invitation =
        await _database.invitations.queryInvitation(id) as InvitationModel?;
    if (invitation == null) {
      throw IdNotFoundException(id: id);
    }
    return invitation.asEntity;
  }
}
