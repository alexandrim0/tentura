import 'dart:typed_data';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_root/domain/entity/coordinates.dart';
import 'package:tentura_server/consts.dart';

part 'input_field_auth_request_token.dart';
part 'input_field_coordinates.dart';
part 'input_field_description.dart';
part 'input_field_drop_image.dart';
part 'input_field_start_at.dart';
part 'input_field_end_at.dart';
part 'input_field_context.dart';
part 'input_field_upload.dart';
part 'input_field_title.dart';
part 'input_field_id.dart';

const kGlobalInputQueryContext = 'queryContext';
const kGlobalInputQueryFile = 'queryFile';
const kGlobalInputQueryJwt = kContextJwtKey;
