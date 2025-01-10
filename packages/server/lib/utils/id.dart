import 'dart:math';

String generateId({
  String prefix = 'U',
}) {
  final buffer = StringBuffer(prefix);
  for (var i = 0; i < 12; i++) {
    buffer.write(_random.nextInt(16).toRadixString(16));
  }
  return buffer.toString();
}

final _random = Random.secure();
