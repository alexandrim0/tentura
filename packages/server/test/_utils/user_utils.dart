import 'dart:convert';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';

final publicKey = base64UrlEncode(convertKey(kJwtPublicKey));

String issueAuthRequestToken([String? userId]) => issueJwt(
      subject: userId ?? generateId(),
      payload: {
        'pk': publicKey,
      },
    )['access_token']! as String;
