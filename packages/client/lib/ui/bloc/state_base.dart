export 'package:flutter/foundation.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:freezed_annotation/freezed_annotation.dart';

enum FetchStatus { isLoading, isSuccess, isFailure, isNavigating }

extension FetchStatusX on FetchStatus {
  bool get isLoading => this == FetchStatus.isLoading;
  bool get isSuccess => this == FetchStatus.isSuccess;
  bool get isFailure => this == FetchStatus.isFailure;
  bool get isNavigating => this == FetchStatus.isNavigating;
}

mixin StateFetchMixin {
  FetchStatus get status;
  Object? get error;

  bool get isSuccess => status.isSuccess;
  bool get isNotSuccess => !status.isSuccess;

  bool get isLoading => status.isLoading;
  bool get isNotLoading => !status.isLoading;

  bool get hasError => error != null || status.isFailure;
  bool get hasNoError => error == null && status.isSuccess;
}

abstract class StateBase {
  const StateBase({
    this.status = const StateIsSuccess(),
  });

  final StateStatus status;

  bool get isSuccess => status is StateIsSuccess;
  bool get isNotSuccess => status is! StateIsSuccess;

  bool get isLoading => status is StateIsLoading;
  bool get isNotLoading => status is! StateIsLoading;

  bool get hasError => status is StateHasError;
  bool get hasNoError => status is! StateHasError;

  bool get isNavigating => status is StateIsNavigating;
  bool get isNotNavigating => status is! StateIsNavigating;
}

sealed class StateStatus {
  static const isSuccess = StateIsSuccess();

  static const isLoading = StateIsLoading();

  const StateStatus();
}

class StateIsSuccess extends StateStatus {
  const StateIsSuccess();
}

class StateIsLoading extends StateStatus {
  const StateIsLoading();
}

class StateIsNavigating extends StateStatus {
  const StateIsNavigating(this.path);

  final String path;
}

class StateHasError extends StateStatus {
  const StateHasError(this.error);

  final Object error;
}
