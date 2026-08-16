import 'package:flutter/material.dart';
import '../core/mock_data.dart';
import '../models/exam_model.dart';

class ExamService extends ChangeNotifier {
  List<ExamModel> _exams = [];
  List<ExamGradeModel> _grades = [];

  List<ExamModel> get exams => _exams;
  List<ExamGradeModel> get grades => _grades;

  ExamService() {
    _exams = List.from(MockData.initialExams);
    _grades = [
      ...MockData.student1Grades,
      ...MockData.studentAtRiskGrades,
    ];
  }

  List<ExamModel> getExamsForCourse(String courseId) {
    return _exams.where((e) => e.courseId == courseId).toList();
  }

  List<ExamGradeModel> getGradesForStudent(String studentId) {
    return _grades.where((g) => g.studentId == studentId).toList()
      ..sort((a, b) => b.gradedAt.compareTo(a.gradedAt));
  }

  List<ExamGradeModel> getGradesForExam(String examId) {
    return _grades.where((g) => g.examId == examId).toList();
  }

  double calculateGpa(String studentId) {
    final studentGrades = getGradesForStudent(studentId);
    if (studentGrades.isEmpty) return 3.5;

    double totalPoints = 0.0;
    for (final grade in studentGrades) {
      totalPoints += grade.gradePoints;
    }
    return double.parse((totalPoints / studentGrades.length).toStringAsFixed(2));
  }

  double calculateAverageScore(String studentId) {
    final studentGrades = getGradesForStudent(studentId);
    if (studentGrades.isEmpty) return 75.0;

    double sum = 0;
    for (final g in studentGrades) {
      sum += g.percentage;
    }
    return double.parse((sum / studentGrades.length).toStringAsFixed(1));
  }

  void createExam(ExamModel exam) {
    _exams.add(exam);
    notifyListeners();
  }

  void recordGrade(ExamGradeModel grade) {
    _grades.removeWhere(
      (g) => g.examId == grade.examId && g.studentId == grade.studentId,
    );
    _grades.add(grade);
    notifyListeners();
  }
}
