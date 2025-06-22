import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/meritrank_repository.dart';
import 'package:tentura_server/data/repository/polling_act_repository.dart';

@Singleton(order: 2)
class PollingCase {
  const PollingCase(this._meritrankRepository, this._pollingActRepository);

  final MeritrankRepository _meritrankRepository;

  final PollingActRepository _pollingActRepository;

  Future<bool> create({
    required String authorId,
    required String pollingId,
    required String variantId,
  }) async {
    await _pollingActRepository.create(
      authorId: authorId,
      pollingId: pollingId,
      variantId: variantId,
    );
    await _meritrankRepository.putEdge(nodeA: authorId, nodeB: variantId);
    return true;
  }
}
