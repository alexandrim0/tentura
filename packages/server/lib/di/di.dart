import 'package:jaspr/server.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' hide Environment;

import 'package:tentura_server/data/database/tentura_db.dart';
import 'package:tentura_server/domain/enum.dart';
import 'package:tentura_server/jaspr_options.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
GetIt configureDependencies(Environment env) {
  Jaspr.initializeApp(options: defaultJasprOptions);
  return getIt.init(environment: env.name);
}

Future<void> closeModules() async {
  await getIt<TenturaDb>().close();
}
