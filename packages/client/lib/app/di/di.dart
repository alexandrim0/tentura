import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:blurhash_shader/blurhash_shader.dart';

import 'di.config.dart';

@InjectableInit()
Future<GetIt> configureDependencies() async {
  await BlurHash.loadShader();
  return GetIt.I.init();
}
