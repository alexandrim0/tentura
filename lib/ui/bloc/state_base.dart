export 'package:flutter/foundation.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:freezed_annotation/freezed_annotation.dart';

enum FetchStatus { isLoading, isSuccess, isFailure }

extension FetchStatusX on FetchStatus {
  bool get isLoading => this == FetchStatus.isLoading;
  bool get isSuccess => this == FetchStatus.isSuccess;
  bool get isFailure => this == FetchStatus.isFailure;
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
