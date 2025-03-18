import 'package:stormberry/stormberry.dart';

import 'package:tentura_root/utils/base64_padded.dart';

import 'package:tentura_server/data/model/user_model.dart';
import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/domain/enum.dart';

Future<void> normalizeKeys() async {
  try {
    configureDependencies(Environment.prod);
  } catch (e) {
    print(e);
  }
  final database = getIt<Database>();
  final users = await database.users.queryUsers();

  for (final user in users) {
    final paddedKey = base64Padded(user.publicKey);
    if (user.publicKey != paddedKey) {
      await database.users.updateOne(
        UserUpdateRequest(id: user.id, publicKey: paddedKey),
      );
      print(paddedKey);
    }
  }
}
