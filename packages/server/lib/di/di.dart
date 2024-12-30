import 'package:jaspr/server.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../jaspr_options.dart';
import 'di.config.dart';

@InjectableInit(
  preferRelativeImports: false,
)
Future<void> configureDependencies() async {
  Jaspr.initializeApp(
    options: defaultJasprOptions,
  );
  GetIt.I.init();
}
