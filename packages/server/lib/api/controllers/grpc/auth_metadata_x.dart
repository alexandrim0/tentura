import 'dart:convert';

import 'package:grpc/grpc.dart' show ServiceCall;

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/entity/jwt_entity.dart';

extension AuthMetadataX on ServiceCall {
  JwtEntity get jwt => JwtEntity.fromJson(
    jsonDecode(clientMetadata![kContextJwtKey]!) as Map<String, dynamic>,
  );
}
