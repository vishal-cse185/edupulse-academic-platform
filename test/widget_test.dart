import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/main.dart';

void main() {
  testWidgets('EduPulse application smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduPulseApp());
    await tester.pumpAndSettle();

    // Verify main app branding is rendered
    expect(find.text('EduPulse'), findsWidgets);
  });
}
