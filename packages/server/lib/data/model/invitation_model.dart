import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/domain/entity/invitation_entity.dart';

import '../service/converter/timestamptz_converter.dart';
import 'user_model.dart';

part 'invitation_model.schema.dart';

extension type const InvitationModel(InvitationView i)
    implements InvitationView {
  InvitationEntity get asEntity => InvitationEntity(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    issuer: (user as UserModel).asEntity,
    invited: (invited as UserModel?)?.asEntity,
  );
}

@Model(tableName: 'invitation')
abstract class Invitation {
  @PrimaryKey()
  String get id;

  User get user;

  User? get invited;

  @UseConverter(TimestamptzConverter())
  DateTime get createdAt;

  @UseConverter(TimestamptzConverter())
  DateTime get updatedAt;
}
