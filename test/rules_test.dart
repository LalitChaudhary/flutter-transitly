import 'package:flutter_test/flutter_test.dart';
import 'package:transitly/domain/rules.dart';

void main() {
  test('legs advances and then stops at the cap', () {
    expect(nextLegs(0), 1);
    expect(capped(12, 12), 12);
    expect(nextLegs(-4), 0);
  });
}
