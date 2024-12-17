import 'package:shelf_plus/shelf_plus.dart';

import '../utils/jwt.dart';
import '../utils/logger.dart';

Future<Map<String, Object>> routeUserRegister(Request request) async {
  try {
    checkJWT(request.headers);
  } catch (e) {
    logger.e(e);
  }
  return {};
}
