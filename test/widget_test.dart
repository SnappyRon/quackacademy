import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quackacademy/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(QuackAcademyApp()); // FIXED HERE

    // Check if app loaded correctly by looking for 'Welcome back, Quacker!'
    expect(find.text('Welcome back, Quacker!'), findsOneWidget);
    
    // Verify that the "Join Now" button exists
    expect(find.text('Join Now'), findsOneWidget);
  });
}
