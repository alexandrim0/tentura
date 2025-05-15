import 'package:tentura_server/domain/use_case/invitation_case.dart';

import '../gql_nodel_base.dart';
import '../input/_input_types.dart';

final class MutationInvitation extends GqlNodeBase {
  MutationInvitation({InvitationCase? invitationCase})
    : _invitationCase = invitationCase ?? GetIt.I<InvitationCase>();

  final InvitationCase _invitationCase;

  List<GraphQLObjectField<dynamic, dynamic>> get all => [invitationAccept];

  GraphQLObjectField<bool, bool> get invitationAccept =>
      GraphQLObjectField<bool, bool>(
        'invitationAccept',
        graphQLBoolean.nonNullable(),
        arguments: [InputFieldId.fieldNonNullable],
        resolve:
            (_, args) => _invitationCase.accept(
              invitationId: InputFieldId.fromArgsNonNullable(args),
              userId: getCredentials(args).sub,
            ),
      );
}
