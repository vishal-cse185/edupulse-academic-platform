import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/widgets/ai_study_tutor_modal.dart';
import 'package:flutter_application/widgets/gpa_simulator_modal.dart';

void main() {
  testWidgets('Academic Learning Assistant Modal opens and displays initial greeting', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AIStudyTutorModal(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('EduPulse Academic Learning Assistant'), findsOneWidget);
    expect(find.textContaining('Hello! I am your EduPulse Academic Learning Assistant'), findsOneWidget);
  });

  testWidgets('GPA & Academic Recovery Simulator renders sliders and projections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GPASimulatorModal(
            currentAttendance: 65.0,
            currentGpa: 2.2,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('"What-If" GPA & Academic Recovery Simulator'), findsOneWidget);
    expect(find.text('Projected Composite'), findsOneWidget);
    expect(find.text('Projected GPA'), findsOneWidget);
  });
}
