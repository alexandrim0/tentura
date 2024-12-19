import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../utils/jwt.dart';

Future<Map<String, Object>> routeUserLogin(Request request) async {
  try {
    checkJWT(request.headers);
  } catch (e) {
    GetIt.I<Logger>().i(e);
  }
  return {};
}
