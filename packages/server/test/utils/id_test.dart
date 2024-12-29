import 'package:test/test.dart';

import 'package:tentura_server/utils/id.dart';

import '../logger.dart';

void main() {
  test(
    'Test of id generator',
    () {
      final userId = generateId();
      logger.i(userId);

      expect(
        userId,
        hasLength(13),
      );
    },
  );
}
