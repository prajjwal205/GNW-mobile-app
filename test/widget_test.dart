// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gnw/main.dart';

void main() {
  testWidgets('App starts with login page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login page is displayed
    expect(find.byType(TextField), findsNWidgets(2)); // Mobile and password fields
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Login functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the text fields
    final mobileField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;

    // Enter credentials
    await tester.enterText(mobileField, '123');
    await tester.enterText(passwordField, '123');
    await tester.pump();

    // Find and tap the login button
    final loginButton = find.text('Login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify that we navigate to the homepage
    expect(find.text('SPONSOR BANNER'), findsOneWidget);
  });
}
