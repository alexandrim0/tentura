import 'package:injectable/injectable.dart';

import '../database/tentura_db.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class MeritrankRepository {
  const MeritrankRepository(this._database);

  final TenturaDb _database;

  Future<void> putEdge({
    required String nodeA,
    required String nodeB,
    double weight = 1.0,
    String context = '',
    int ticker = 0,
  }) => _database
      .customSelect(
        // ignore: use_raw_strings //
        'SELECT mr_put_edge(\$1, \$2, \$3, \$4, \$5) AS _c0',
        variables: [
          Variable<String>(nodeA),
          Variable<String>(nodeB),
          Variable<double>(weight),
          Variable<String>(context),
          Variable<int>(ticker),
        ],
      )
      .getSingle();

  Future<void> deleteEdge({
    required String nodeA,
    required String nodeB,
    String context = '',
  }) => _database
      .customSelect(
        // ignore: use_raw_strings //
        'SELECT mr_delete_edge(\$1, \$2, \$3) AS _c0',
        variables: [
          Variable<String>(nodeA),
          Variable<String>(nodeB),
          Variable<String>(context),
        ],
      )
      .getSingle();
}
