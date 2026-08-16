import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/mock_data.dart';
import '../models/assignment_model.dart';

class AssignmentService extends ChangeNotifier {
  List<AssignmentModel> _assignments = [];
  List<AssignmentSubmissionModel> _submissions = [];

  List<AssignmentModel> get assignments => _assignments;
  List<AssignmentSubmissionModel> get submissions => _submissions;

  AssignmentService() {
    _assignments = List.from(MockData.initialAssignments);
    _submissions = List.from(MockData.initialSubmissions);
  }

  List<AssignmentModel> getAssignmentsForCourse(String courseId) {
    return _assignments.where((a) => a.courseId == courseId).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<AssignmentModel> getAssignmentsForStudent(List<String> enrolledCourseIds) {
    return _assignments
        .where((a) => enrolledCourseIds.contains(a.courseId))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<AssignmentSubmissionModel> getSubmissionsForStudent(String studentId) {
    return _submissions.where((s) => s.studentId == studentId).toList();
  }

  List<AssignmentSubmissionModel> getSubmissionsForAssignment(
      String assignmentId) {
    return _submissions.where((s) => s.assignmentId == assignmentId).toList();
  }

  AssignmentSubmissionModel? getSubmission(
      String assignmentId, String studentId) {
    try {
      return _submissions.firstWhere(
        (s) => s.assignmentId == assignmentId && s.studentId == studentId,
      );
    } catch (_) {
      return null;
    }
  }

  void createAssignment(AssignmentModel assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  Future<AssignmentSubmissionModel> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String studentName,
    required String submissionContent,
  }) async {
    // Generate automated AI feedback
    final assignment = _assignments.firstWhere(
      (a) => a.id == assignmentId,
      orElse: () => _assignments.first,
    );

    final aiEvaluation = _generateAiAnalysis(
      assignment: assignment,
      content: submissionContent,
    );

    final newSubmission = AssignmentSubmissionModel(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      assignmentId: assignmentId,
      studentId: studentId,
      studentName: studentName,
      submissionContent: submissionContent,
      submittedAt: DateTime.now(),
      score: aiEvaluation['estimatedScore'] as double?,
      aiFeedback: aiEvaluation['feedback'] as String,
      weakConceptsIdentified:
          aiEvaluation['weakConcepts'] as List<String>,
      status: AssignmentStatus.submitted,
    );

    _submissions.removeWhere(
      (s) => s.assignmentId == assignmentId && s.studentId == studentId,
    );
    _submissions.add(newSubmission);
    notifyListeners();
    return newSubmission;
  }

  void gradeSubmission({
    required String submissionId,
    required double score,
    required String teacherFeedback,
  }) {
    final index = _submissions.indexWhere((s) => s.id == submissionId);
    if (index != -1) {
      _submissions[index] = _submissions[index].copyWith(
        score: score,
        teacherFeedback: teacherFeedback,
        status: AssignmentStatus.graded,
      );
      notifyListeners();
    }
  }

  Map<String, dynamic> _generateAiAnalysis({
    required AssignmentModel assignment,
    required String content,
  }) {
    final lower = content.toLowerCase();
    final List<String> weakConcepts = [];
    double estimatedScore = 85.0;
    String feedback = '';

    if (lower.length < 50) {
      estimatedScore = 55.0;
      weakConcepts.add('Depth of Explanation');
      feedback =
          '⚠️ AI Evaluation: Submission appears brief. Please provide complete code implementations and complexity proofs for higher marks.';
    } else if (lower.contains('http') || lower.contains('github') || lower.contains('class') || lower.contains('function')) {
      estimatedScore = 92.0;
      feedback =
          '✅ AI Evaluation: High structural quality detected. Code satisfies algorithmic rubric criteria and adheres to optimal time complexity standards.';
    } else {
      estimatedScore = 78.0;
      weakConcepts.add('Practical Application');
      feedback =
          '💡 AI Evaluation: Solid conceptual breakdown. Recommend adding unit tests and benchmark timings to secure full credit.';
    }

    return {
      'estimatedScore': estimatedScore,
      'feedback': feedback,
      'weakConcepts': weakConcepts,
    };
  }
}
