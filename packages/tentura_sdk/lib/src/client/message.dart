import 'dart:isolate';

sealed class Message {}

class InitMessage extends Message {
  InitMessage(this.replyPort);

  final SendPort replyPort;
}

sealed class RequestMessage extends Message {}

sealed class ResponseMessage<T extends Object> extends Message {
  ResponseMessage({this.value, this.error});

  final T? value;
  final Object? error;

  T get valueOrException {
    if (value != null) return value!;
    // ignore: only_throw_errors
    throw switch (error) {
      final Error e => e,
      final Exception e => e,
      _ => Exception(error),
    };
  }
}

// GetToken
class GetTokenRequest extends RequestMessage {}

class GetTokenResponse extends ResponseMessage<String> {
  GetTokenResponse({super.value, super.error});
}
