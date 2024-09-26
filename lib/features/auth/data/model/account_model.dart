import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entity/account.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required String seed,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, Object?> json) =>
      _$AccountModelFromJson(json);

  factory AccountModel.fromEntity(Account entity) =>
      AccountModel(id: entity.id, seed: entity.seed);

  const AccountModel._();

  Account get toEntity => Account(id: id, seed: seed);
}
