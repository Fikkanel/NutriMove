import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimove/app.dart';

void main() {
  testWidgets('NutriMove app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const NutriMoveApp());
    // Verify splash screen loads
    expect(find.text('NutriMove'), findsOneWidget);
  });
}
