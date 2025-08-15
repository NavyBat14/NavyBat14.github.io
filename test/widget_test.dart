import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skymiles_app/main.dart';

void main() {
  testWidgets('SkymilesApp launches without crashing', (
    WidgetTester tester,
  ) async {
    // Build the SkymilesApp widget and trigger a frame
    await tester.pumpWidget(SkymilesApp());

    // Expect to find the plane icon on the initial screen
    expect(find.byIcon(Icons.airplanemode_active), findsOneWidget);
  });
}
