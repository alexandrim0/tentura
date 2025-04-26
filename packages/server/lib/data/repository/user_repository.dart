import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/model/invitation_model.dart';
import 'package:tentura_server/data/model/user_model.dart';
import 'package:tentura_server/data/model/vote_user_model.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/domain/exception.dart';

export 'package:tentura_server/domain/entity/user_entity.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class UserRepository {
  const UserRepository(this._database, this._env);

  final Database _database;

  final Env _env;

  Future<void> createUser({required UserEntity user}) async {
    final now = DateTime.timestamp();
    await _database.users.insertOne(
      UserInsertRequest(
        id: user.id,
        title: user.title,
        publicKey: user.publicKey,
        description: user.description,
        hasPicture: user.hasPicture,
        picHeight: user.picHeight,
        picWidth: user.picWidth,
        blurHash: user.blurHash,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> inviteUser({
    required UserEntity user,
    required String inviteId,
  }) async {
    await _database.runTx<void>((session) async {
      final invitation = await _database.invitations.queryInvitation(inviteId);

      if (invitation == null ||
          invitation.invited != null ||
          invitation.createdAt
              .add(_env.invitationTTL)
              .isAfter(DateTime.timestamp())) {
        throw const InvitationWrongException();
      }

      final now = DateTime.timestamp();
      await session.users.insertOne(
        UserInsertRequest(
          id: user.id,
          title: user.title,
          publicKey: user.publicKey,
          description: user.description,
          hasPicture: user.hasPicture,
          picHeight: user.picHeight,
          picWidth: user.picWidth,
          blurHash: user.blurHash,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await _database.invitations.updateOne(
        InvitationUpdateRequest(id: inviteId, invitedId: user.id),
      );
      await _database.voteUsers.insertMany([
        VoteUserInsertRequest(
          subjectId: user.id,
          objectId: inviteId,
          amount: 1,
          createdAt: now,
          updatedAt: now,
        ),
        VoteUserInsertRequest(
          subjectId: inviteId,
          objectId: user.id,
          amount: 1,
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    });
  }

  Future<UserEntity> getUserById(String id) async => switch (await _database
      .users
      .queryUser(id)) {
    final UserModel m => m.asEntity,
    null => throw IdNotFoundException(id: id),
  };

  Future<UserEntity> getUserByPublicKey(String publicKey) async {
    final users = await _database.users.queryUsers(
      QueryParams(where: 'public_key=@pk', values: {'pk': publicKey}),
    );
    if (users.isEmpty) {
      throw IdNotFoundException(id: publicKey);
    }
    return (users.first as UserModel).asEntity;
  }

  Future<void> updateUser({
    required String id,
    String? title,
    String? description,
    bool? hasImage,
    String? blurHash,
    int? imageHeight,
    int? imageWidth,
  }) => _database.users.updateOne(
    UserUpdateRequest(
      id: id,
      title: title,
      description: description,
      hasPicture: hasImage,
      blurHash: blurHash,
      picHeight: imageHeight,
      picWidth: imageWidth,
    ),
  );

  Future<void> deleteUserById({required String id}) =>
      _database.users.deleteOne(id);
}
