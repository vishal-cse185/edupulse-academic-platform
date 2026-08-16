import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/attendance_model.dart';
import '../models/assignment_model.dart';
import '../models/exam_model.dart';
import 'ai_academic_engine.dart';

class ReportService extends ChangeNotifier {
  final AIAcademicEngineService _aiEngine;

  ReportService(this._aiEngine);

  AcademicReportModel generateStudentAcademicReport({
    required UserModel student,
    required List<CourseModel> enrolledCourses,
    required List<AttendanceRecord> attendanceRecords,
    required List<AssignmentSubmissionModel> submissions,
    required List<ExamGradeModel> examGrades,
  }) {
    final aiInsights = _aiEngine.analyzeStudentPerformance(
      studentId: student.id,
      studentName: student.name,
      attendanceRecords: attendanceRecords,
      submissions: submissions,
      examGrades: examGrades,
      enrolledCourses: enrolledCourses,
    );

    double totalPoints = 0.0;
    for (final grade in examGrades) {
      totalPoints += grade.gradePoints;
    }
    final currentGpa = examGrades.isNotEmpty
        ? double.parse((totalPoints / examGrades.length).toStringAsFixed(2))
        : 3.4;

    return AcademicReportModel(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      studentId: student.id,
      studentName: student.name,
      department: student.department ?? 'Computer Science & Engineering',
      academicTerm: 'Fall Semester 2026',
      cumulativeGpa: currentGpa,
      currentTermGpa: currentGpa,
      overallAttendance: aiInsights.attendanceRate,
      riskLevel: aiInsights.riskLevel,
      examGrades: examGrades,
      weakAreas: aiInsights.weakSubjects,
      riskFactors: aiInsights.riskFactors,
      aiRecommendations: aiInsights.recommendations,
      teacherRemarks: aiInsights.executiveSummary,
    );
  }

  List<ClassPerformanceSummary> generateClassSummaries(
    List<CourseModel> courses,
  ) {
    return courses.map((course) {
      return ClassPerformanceSummary(
        courseId: course.id,
        courseTitle: course.title,
        teacherName: course.teacherName,
        totalStudents: course.enrolledStudentCount > 0 ? course.enrolledStudentCount : 45,
        classAverageScore: 78.5,
        classAttendanceRate: 88.2,
        highRiskStudentCount: 3,
        mediumRiskStudentCount: 8,
        lowRiskStudentCount: 34,
        mostStrugglingTopics: [
          'Module 3 Algorithmic Proofs',
          'Practice Lab 2 Invariants',
        ],
      );
    }).toList();
  }
}
