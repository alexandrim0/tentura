import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/repository/invitation_repository.dart';

@Injectable(order: 2)
class InvitationCase {
  InvitationCase(this._env, this._invitationRepository);

  final Env _env;

  final InvitationRepository _invitationRepository;

  Future<bool> accept({
    required String invitationId,
    required String userId,
  }) async {
    final invitation = await _invitationRepository.getById(invitationId);
    return false;
  }
}
