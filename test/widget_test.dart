import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:padee/main.dart';
import 'package:padee/views/home_screen.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const PadeeApp());
    await tester.pumpAndSettle();

    // Verify that our app renders HomeScreen without crashing.
    expect(find.byType(HomeScreen), findsOneWidget);
    // Since default locale is Myanmar ('my_MM'), 'ပုတီး' is rendered.
    expect(find.text('ပုတီး'), findsOneWidget);
  });
}
