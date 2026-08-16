class ExamModel {
  final String id;
  final String courseId;
  final String courseTitle;
  final String title;
  final DateTime examDate;
  final int durationMinutes;
  final int totalMarks;
  final double weightagePercentage;
  final String room;

  ExamModel({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.title,
    required this.examDate,
    required this.durationMinutes,
    required this.totalMarks,
    this.weightagePercentage = 30.0,
    this.room = 'Exam Hall A',
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String,
      title: json['title'] as String,
      examDate: DateTime.parse(json['examDate'] as String),
      durationMinutes: json['durationMinutes'] as int? ?? 120,
      totalMarks: json['totalMarks'] as int? ?? 100,
      weightagePercentage:
          (json['weightagePercentage'] as num?)?.toDouble() ?? 30.0,
      room: json['room'] as String? ?? 'Exam Hall A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'title': title,
      'examDate': examDate.toIso8601String(),
      'durationMinutes': durationMinutes,
      'totalMarks': totalMarks,
      'weightagePercentage': weightagePercentage,
      'room': room,
    };
  }
}

class ExamGradeModel {
  final String id;
  final String examId;
  final String examTitle;
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseTitle;
  final String subject;
  final double marksObtained;
  final double totalMarks;
  final DateTime gradedAt;
  final String? remarks;

  ExamGradeModel({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseTitle,
    required this.subject,
    required this.marksObtained,
    required this.totalMarks,
    DateTime? gradedAt,
    this.remarks,
  }) : gradedAt = gradedAt ?? DateTime.now();

  double get percentage =>
      totalMarks == 0 ? 0.0 : (marksObtained / totalMarks) * 100.0;

  String get gradeLetter {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  double get gradePoints {
    if (percentage >= 90) return 4.0;
    if (percentage >= 80) return 3.7;
    if (percentage >= 70) return 3.0;
    if (percentage >= 60) return 2.0;
    if (percentage >= 50) return 1.0;
    return 0.0;
  }

  factory ExamGradeModel.fromJson(Map<String, dynamic> json) {
    return ExamGradeModel(
      id: json['id'] as String,
      examId: json['examId'] as String,
      examTitle: json['examTitle'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String,
      subject: json['subject'] as String? ?? 'General',
      marksObtained: (json['marksObtained'] as num).toDouble(),
      totalMarks: (json['totalMarks'] as num).toDouble(),
      gradedAt: json['gradedAt'] != null
          ? DateTime.parse(json['gradedAt'] as String)
          : DateTime.now(),
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examId': examId,
      'examTitle': examTitle,
      'studentId': studentId,
      'studentName': studentName,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'subject': subject,
      'marksObtained': marksObtained,
      'totalMarks': totalMarks,
      'gradedAt': gradedAt.toIso8601String(),
      'remarks': remarks,
    };
  }
}
