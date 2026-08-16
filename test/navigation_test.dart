import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/main.dart';

void main() {
  testWidgets('App renders Home Screen and Navigation Header properly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduPulseApp());
    await tester.pumpAndSettle();

    // Verify Brand Title and Explore Courses button are present
    expect(find.text('EduPulse AI'), findsWidgets);
    expect(find.text('Explore Courses'), findsOneWidget);
  });
}
