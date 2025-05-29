import 'dart:io' show Platform;

import 'package:tentura_root/consts.dart';

export 'package:tentura_root/consts.dart';

const kContextJwtKey = 'contextJwt';

final kInvitationTTL = Duration(
  hours:
      int.tryParse(Platform.environment['INVITATION_TTL'] ?? '') ??
      kInvitationDefaultTTL,
);
