import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/user_vsids_model.dart';
import 'package:tentura_server/domain/exception.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class VsidsRepository {
  const VsidsRepository(this._database);

  final Database _database;

  Future<int> getUserVsids({required String userId}) async {
    final vsids = await _database.vsidses.queryVsidses(
      QueryParams(where: 'user_id=@userId', values: {'userId': userId}),
    );
    if (vsids.isEmpty) {
      throw IdNotFoundException(id: userId);
    }
    return vsids.first.counter;
  }
}
