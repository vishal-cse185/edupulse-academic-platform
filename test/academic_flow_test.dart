import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/core/constants.dart';
import 'package:flutter_application/models/attendance_model.dart';
import 'package:flutter_application/models/exam_model.dart';
import 'package:flutter_application/services/attendance_service.dart';
import 'package:flutter_application/services/assignment_service.dart';
import 'package:flutter_application/services/exam_service.dart';

void main() {
  group('Academic Workflow Tests', () {
    test('AttendanceService computes accurate percentage and handles late records', () {
      final attService = AttendanceService();
      final now = DateTime.now();

      attService.markAttendance(
        AttendanceRecord(
          id: 'test_1',
          studentId: 'test_student',
          studentName: 'Test Student',
          courseId: 'crs_001',
          courseCode: 'CS301',
          courseTitle: 'Data Structures',
          date: now,
          status: AttendanceStatus.present,
        ),
      );

      attService.markAttendance(
        AttendanceRecord(
          id: 'test_2',
          studentId: 'test_student',
          studentName: 'Test Student',
          courseId: 'crs_001',
          courseCode: 'CS301',
          courseTitle: 'Data Structures',
          date: now.subtract(const Duration(days: 1)),
          status: AttendanceStatus.late,
        ),
      );

      final pct = attService.getOverallAttendancePercentage('test_student');
      expect(pct, 100.0); // Both present and late count towards attendance
    });

    test('AssignmentService triggers automated AI evaluation on submission', () async {
      final asgService = AssignmentService();

      final submission = await asgService.submitAssignment(
        assignmentId: 'asg_001',
        studentId: 'std_001',
        studentName: 'Alex Johnson',
        submissionContent:
            'https://github.com/alex/rbtree-implementation\nImplemented balanced rotations with O(log N) depth proof.',
      );

      expect(submission.aiFeedback != null, true);
      expect(submission.score, isNotNull);
      expect(submission.score! >= 80.0, true);
    });

    test('ExamService computes correct GPA on standard 4.0 scale', () {
      final examService = ExamService();

      examService.recordGrade(
        ExamGradeModel(
          id: 'g1',
          examId: 'ex1',
          examTitle: 'Test Exam 1',
          studentId: 'test_gpa_student',
          studentName: 'Test GPA',
          courseId: 'crs_1',
          courseTitle: 'Course 1',
          subject: 'CS',
          marksObtained: 95.0,
          totalMarks: 100.0, // A+ -> 4.0
        ),
      );

      examService.recordGrade(
        ExamGradeModel(
          id: 'g2',
          examId: 'ex2',
          examTitle: 'Test Exam 2',
          studentId: 'test_gpa_student',
          studentName: 'Test GPA',
          courseId: 'crs_2',
          courseTitle: 'Course 2',
          subject: 'Math',
          marksObtained: 85.0,
          totalMarks: 100.0, // A -> 3.7
        ),
      );

      final gpa = examService.calculateGpa('test_gpa_student');
      expect(gpa, closeTo(3.85, 0.05));
    });
  });
}
