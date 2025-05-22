import 'dart:developer';
import 'package:test/test.dart';

import 'package:tentura_server/utils/id.dart';

void main() {
  test('Test of id generator', () {
    final userId = generateId('U');
    log(userId);

    expect(userId, hasLength(13));
  });
}
