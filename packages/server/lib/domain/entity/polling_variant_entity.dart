import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/utils/id.dart';

part 'polling_variant_entity.freezed.dart';

@freezed
abstract class PollingVariantEntity with _$PollingVariantEntity {
  static String get newId => generateId('V');

  const factory PollingVariantEntity({
    required String id,
    required String pollingId,
    required String description,
  }) = _PollingVariantEntity;

  const PollingVariantEntity._();

  Map<String, Object> get asJson => {'id': id};
}
