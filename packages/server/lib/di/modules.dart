import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  Logger get logger => Logger();
}
