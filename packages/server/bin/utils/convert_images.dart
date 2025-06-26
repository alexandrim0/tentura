import 'package:tentura_server/env.dart';
import 'package:tentura_server/app/di.dart';
// import 'package:tentura_server/data/database/tentura_db.dart';

Future<void> convertImages() async {
  final getIt = await configureDependencies(Env.prod());
  // final database = getIt<TenturaDb>();

  await getIt.reset();
}
