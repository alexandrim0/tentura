import 'dart:convert';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/jwt.dart';

const kIsIntegrationTest = bool.fromEnvironment(
  'IS_INTEGRATION',
);

final publicKey = base64UrlEncode(convertKey(kJwtPublicKey));
