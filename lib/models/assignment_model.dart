import '../core/constants.dart';

class AssignmentModel {
  final String id;
  final String courseId;
  final String courseTitle;
  final String teacherId;
  final String title;
  final String description;
  final DateTime dueDate;
  final int maxScore;
  final List<String> rubricCriteria;
  final String subject;

  AssignmentModel({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.maxScore,
    this.rubricCriteria = const [],
    required this.subject,
  });

  bool get isPastDue => DateTime.now().isAfter(dueDate);

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String,
      teacherId: json['teacherId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      maxScore: json['maxScore'] as int? ?? 100,
      rubricCriteria: List<String>.from(json['rubricCriteria'] ?? []),
      subject: json['subject'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'maxScore': maxScore,
      'rubricCriteria': rubricCriteria,
      'subject': subject,
    };
  }
}

class AssignmentSubmissionModel {
  final String id;
  final String assignmentId;
  final String studentId;
  final String studentName;
  final String submissionContent;
  final DateTime submittedAt;
  final double? score;
  final String? teacherFeedback;
  final String? aiFeedback;
  final List<String> weakConceptsIdentified;
  final AssignmentStatus status;

  AssignmentSubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    required this.submissionContent,
    required this.submittedAt,
    this.score,
    this.teacherFeedback,
    this.aiFeedback,
    this.weakConceptsIdentified = const [],
    required this.status,
  });

  factory AssignmentSubmissionModel.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmissionModel(
      id: json['id'] as String,
      assignmentId: json['assignmentId'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      submissionContent: json['submissionContent'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      score: (json['score'] as num?)?.toDouble(),
      teacherFeedback: json['teacherFeedback'] as String?,
      aiFeedback: json['aiFeedback'] as String?,
      weakConceptsIdentified:
          List<String>.from(json['weakConceptsIdentified'] ?? []),
      status: AssignmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AssignmentStatus.submitted,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'studentName': studentName,
      'submissionContent': submissionContent,
      'submittedAt': submittedAt.toIso8601String(),
      'score': score,
      'teacherFeedback': teacherFeedback,
      'aiFeedback': aiFeedback,
      'weakConceptsIdentified': weakConceptsIdentified,
      'status': status.name,
    };
  }

  AssignmentSubmissionModel copyWith({
    String? id,
    String? assignmentId,
    String? studentId,
    String? studentName,
    String? submissionContent,
    DateTime? submittedAt,
    double? score,
    String? teacherFeedback,
    String? aiFeedback,
    List<String>? weakConceptsIdentified,
    AssignmentStatus? status,
  }) {
    return AssignmentSubmissionModel(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      submissionContent: submissionContent ?? this.submissionContent,
      submittedAt: submittedAt ?? this.submittedAt,
      score: score ?? this.score,
      teacherFeedback: teacherFeedback ?? this.teacherFeedback,
      aiFeedback: aiFeedback ?? this.aiFeedback,
      weakConceptsIdentified:
          weakConceptsIdentified ?? this.weakConceptsIdentified,
      status: status ?? this.status,
    );
  }
}
