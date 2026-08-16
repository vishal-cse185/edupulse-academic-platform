import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/core/constants.dart';
import 'package:flutter_application/core/mock_data.dart';
import 'package:flutter_application/models/attendance_model.dart';
import 'package:flutter_application/models/exam_model.dart';
import 'package:flutter_application/models/assignment_model.dart';
import 'package:flutter_application/services/ai_academic_engine.dart';

void main() {
  group('AI Academic Intelligence Engine Tests', () {
    late AIAcademicEngineService aiEngine;

    setUp(() {
      aiEngine = AIAcademicEngineService();
    });

    test('Identifies High-Risk student with low attendance (<75%) and low grades', () {
      final attendance = [
        AttendanceRecord(
          id: 'att_1',
          studentId: 'std_002',
          studentName: 'David Smith',
          courseId: 'crs_001',
          courseCode: 'CS301',
          courseTitle: 'Data Structures',
          date: DateTime.now(),
          status: AttendanceStatus.absent,
        ),
        AttendanceRecord(
          id: 'att_2',
          studentId: 'std_002',
          studentName: 'David Smith',
          courseId: 'crs_001',
          courseCode: 'CS301',
          courseTitle: 'Data Structures',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: AttendanceStatus.absent,
        ),
        AttendanceRecord(
          id: 'att_3',
          studentId: 'std_002',
          studentName: 'David Smith',
          courseId: 'crs_001',
          courseCode: 'CS301',
          courseTitle: 'Data Structures',
          date: DateTime.now().subtract(const Duration(days: 2)),
          status: AttendanceStatus.present,
        ),
      ];

      final examGrades = [
        ExamGradeModel(
          id: 'grd_1',
          examId: 'exm_1',
          examTitle: 'Midterm',
          studentId: 'std_002',
          studentName: 'David Smith',
          courseId: 'crs_001',
          courseTitle: 'Data Structures & Algorithms',
          subject: 'Data Structures',
          marksObtained: 45.0,
          totalMarks: 100.0,
        ),
      ];

      final submissions = [
        AssignmentSubmissionModel(
          id: 'sub_1',
          assignmentId: 'asg_1',
          studentId: 'std_002',
          studentName: 'David Smith',
          submissionContent: 'Brief text',
          submittedAt: DateTime.now(),
          score: 40.0,
          status: AssignmentStatus.graded,
        ),
      ];

      final insight = aiEngine.analyzeStudentPerformance(
        studentId: 'std_002',
        studentName: 'David Smith',
        attendanceRecords: attendance,
        submissions: submissions,
        examGrades: examGrades,
        enrolledCourses: MockData.initialCourses,
      );

      expect(insight.riskLevel, RiskLevel.high);
      expect(insight.attendanceRate < 75.0, true);
      expect(insight.riskFactors.isNotEmpty, true);
      expect(insight.weakSubjects.isNotEmpty, true);
      expect(insight.recommendations.isNotEmpty, true);
      expect(insight.trend, 'declining');
    });

    test('Recognizes Low-Risk (On Track) student with high attendance and top marks', () {
      final attendance = [
        AttendanceRecord(
          id: 'att_1',
          studentId: 'std_001',
          studentName: 'Alex Johnson',
          courseId: 'crs_001',
          courseCode: 'CS301',
          courseTitle: 'Data Structures',
          date: DateTime.now(),
          status: AttendanceStatus.present,
        ),
        AttendanceRecord(
          id: 'att_2',
          studentId: 'std_001',
          studentName: 'Alex Johnson',
          courseId: 'crs_001',
          courseCode: 'CS301',
          courseTitle: 'Data Structures',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: AttendanceStatus.present,
        ),
      ];

      final examGrades = [
        ExamGradeModel(
          id: 'grd_1',
          examId: 'exm_1',
          examTitle: 'Midterm',
          studentId: 'std_001',
          studentName: 'Alex Johnson',
          courseId: 'crs_001',
          courseTitle: 'Data Structures & Algorithms',
          subject: 'Data Structures',
          marksObtained: 92.0,
          totalMarks: 100.0,
        ),
      ];

      final submissions = [
        AssignmentSubmissionModel(
          id: 'sub_1',
          assignmentId: 'asg_1',
          studentId: 'std_001',
          studentName: 'Alex Johnson',
          submissionContent: 'Detailed code repository implementation with tests',
          submittedAt: DateTime.now(),
          score: 95.0,
          status: AssignmentStatus.graded,
        ),
      ];

      final insight = aiEngine.analyzeStudentPerformance(
        studentId: 'std_001',
        studentName: 'Alex Johnson',
        attendanceRecords: attendance,
        submissions: submissions,
        examGrades: examGrades,
        enrolledCourses: MockData.initialCourses,
      );

      expect(insight.riskLevel, RiskLevel.low);
      expect(insight.overallScore >= 85.0, true);
      expect(insight.trend, 'improving');
    });

    test('Generates institutional cohort diagnostics and bottlenecks', () {
      final cohort = aiEngine.generateClassCohortAnalysis(
        MockData.initialCourses,
        MockData.student1Grades,
        MockData.getStudent1Attendance(),
      );

      expect(cohort['totalStudents'], greaterThan(0));
      expect(cohort['topStrugglingTopics'] is List, true);
      expect((cohort['topStrugglingTopics'] as List).isNotEmpty, true);
      expect((cohort['recommendedInterventions'] as List).isNotEmpty, true);
    });
  });
}
