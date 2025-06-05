import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../env.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(ignoreUnregisteredTypes: [Env])
Future<GetIt> configureDependencies(Env env) async {
  getIt.registerSingleton(env);
  return getIt.init(environment: env.environment);
}
