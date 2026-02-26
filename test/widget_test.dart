import 'package:flutter_test/flutter_test.dart';
import 'package:padee/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PadeeApp());

    // Verify that our app renders without crashing, by finding the app bar title.
    expect(find.text('Padee Counter'), findsOneWidget);
  });
}
