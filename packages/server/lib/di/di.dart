import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' hide Environment;

import 'package:tentura_server/domain/enum.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<GetIt> configureDependencies(Environment env) =>
    getIt.init(environment: env.name);
