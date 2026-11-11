import 'package:flutter_test/flutter_test.dart';
import 'package:transitly/main.dart';

void main() {
  testWidgets('demo profile opens Transitly', (tester) async {
    await tester.pumpWidget(const TransitlyApp());
    await tester.tap(find.text('Open Transitly'));
    await tester.pumpAndSettle();
    expect(find.text('Trip'), findsOneWidget);
    expect(find.textContaining('legs'), findsWidgets);
  });
}
