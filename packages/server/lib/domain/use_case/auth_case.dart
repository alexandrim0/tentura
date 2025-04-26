import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/domain/exception.dart';

import '../entity/jwt_entity.dart';
import '../enum.dart';

@Injectable(order: 2)
class AuthCase {
  AuthCase(this._env, this._userRepository);

  final Env _env;

  final UserRepository _userRepository;

  ///
  /// Parse and verify JWT issued before and signed with server private key
  ///
  JwtEntity parseAndVerifyJwt({required String token}) {
    final jwt = JWT.verify(token, _env.publicKey);
    final payload = jwt.payload as Map<String, Object?>;
    final roleList = (payload['roles'] as String? ?? '').split(',');

    // TBD: add all other claims
    return JwtEntity(
      sub: jwt.subject!,
      roles: UserRoles.values.where((e) => roleList.contains(e.name)).toSet(),
    );
  }

  Future<JwtEntity> signIn({required String authRequestToken}) async {
    final jwt = _verifyAuthRequest(token: authRequestToken);
    final user = await _userRepository.getUserByPublicKey(
      (jwt.payload as Map)['pk'] as String,
    );

    return _issueJwt(subject: user.id);
  }

  Future<JwtEntity> signUp({
    required String authRequestToken,
    required String title,
  }) async {
    final jwt = _verifyAuthRequest(token: authRequestToken);
    final payload = jwt.payload as Map<String, dynamic>;
    final newUser = UserEntity(
      id: UserEntity.newId,
      publicKey: payload['pk']! as String,
      title: title,
    );

    if (_env.isNeedInvite) {
      final _ = switch (payload['inv']) {
        final String inviteId => await _userRepository.inviteUser(
          inviteId: inviteId,
          user: newUser,
        ),
        _ =>
          throw const IdWrongException(
            description: 'Invite attribute not found!',
          ),
      };
    } else {
      await _userRepository.createUser(user: newUser);
    }
    return _issueJwt(subject: newUser.id);
  }

  JWT _verifyAuthRequest({required String token}) {
    final jwtDecoded = JWT.decode(token);

    if (jwtDecoded.header?['alg'] != 'EdDSA') {
      throw JWTInvalidException('Wrong JWT algo!');
    }

    return JWT.verify(
      token,
      EdDSAPublicKey(
        base64Decode(
          base64.normalize((jwtDecoded.payload as Map)['pk']! as String),
        ),
      ),
    );
  }

  JwtEntity _issueJwt({required String subject}) {
    final jwtId = _uuid.v8();
    final roles = {UserRoles.user};
    return JwtEntity(
      jti: jwtId,
      sub: subject,
      iss: kServerName,
      exp: kJwtExpiresIn,
      roles: roles,
      rawToken: JWT(
        {'roles': roles.join(',')},
        jwtId: jwtId,
        subject: subject,
        issuer: kServerName,
      ).sign(
        _env.privateKey,
        algorithm: JWTAlgorithm.EdDSA,
        expiresIn: const Duration(seconds: kJwtExpiresIn),
      ),
    );
  }

  static const _uuid = Uuid();
}
