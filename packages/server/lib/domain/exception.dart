class IdNotFoundException implements Exception {
  const IdNotFoundException([this.message]);

  final String? message;

  @override
  String toString() => 'IdNotFoundException: [$message]';
}
