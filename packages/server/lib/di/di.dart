import 'package:jaspr/server.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' hide Environment;

import 'package:tentura_server/domain/enum.dart';
import 'package:tentura_server/jaspr_options.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies(Environment env) {
  Jaspr.initializeApp(
    options: defaultJasprOptions,
    useIsolates: false,
  );
  getIt.init(environment: env.name);
}
