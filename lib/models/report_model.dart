import '../core/constants.dart';
import 'ai_insight_model.dart';
import 'exam_model.dart';
import 'attendance_model.dart';

class AcademicReportModel {
  final String id;
  final String studentId;
  final String studentName;
  final String department;
  final String academicTerm;
  final double cumulativeGpa;
  final double currentTermGpa;
  final double overallAttendance;
  final RiskLevel riskLevel;
  final List<SubjectAttendanceSummary> attendanceBreakdown;
  final List<ExamGradeModel> examGrades;
  final List<WeakSubjectDetail> weakAreas;
  final List<String> riskFactors;
  final List<StudyRecommendation> aiRecommendations;
  final String teacherRemarks;
  final DateTime generatedDate;

  AcademicReportModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.department,
    required this.academicTerm,
    required this.cumulativeGpa,
    required this.currentTermGpa,
    required this.overallAttendance,
    required this.riskLevel,
    this.attendanceBreakdown = const [],
    this.examGrades = const [],
    this.weakAreas = const [],
    this.riskFactors = const [],
    this.aiRecommendations = const [],
    this.teacherRemarks = 'Good general progress with targeted improvement areas.',
    DateTime? generatedDate,
  }) : generatedDate = generatedDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'department': department,
      'academicTerm': academicTerm,
      'cumulativeGpa': cumulativeGpa,
      'currentTermGpa': currentTermGpa,
      'overallAttendance': overallAttendance,
      'riskLevel': riskLevel.name,
      'weakAreas': weakAreas.map((e) => e.toJson()).toList(),
      'riskFactors': riskFactors,
      'aiRecommendations': aiRecommendations.map((e) => e.toJson()).toList(),
      'teacherRemarks': teacherRemarks,
      'generatedDate': generatedDate.toIso8601String(),
    };
  }
}

class ClassPerformanceSummary {
  final String courseId;
  final String courseTitle;
  final String teacherName;
  final int totalStudents;
  final double classAverageScore;
  final double classAttendanceRate;
  final int highRiskStudentCount;
  final int mediumRiskStudentCount;
  final int lowRiskStudentCount;
  final List<String> mostStrugglingTopics;

  ClassPerformanceSummary({
    required this.courseId,
    required this.courseTitle,
    required this.teacherName,
    required this.totalStudents,
    required this.classAverageScore,
    required this.classAttendanceRate,
    this.highRiskStudentCount = 0,
    this.mediumRiskStudentCount = 0,
    this.lowRiskStudentCount = 0,
    this.mostStrugglingTopics = const [],
  });
}
