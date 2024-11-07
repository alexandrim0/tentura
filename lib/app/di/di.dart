import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@InjectableInit(
  preferRelativeImports: false,
)
Future<void> configureDependencies() => GetIt.I.init();
