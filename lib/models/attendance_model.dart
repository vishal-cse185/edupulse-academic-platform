import '../core/constants.dart';

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseCode;
  final String courseTitle;
  final DateTime date;
  final AttendanceStatus status;
  final String? remarks;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseCode,
    required this.courseTitle,
    required this.date,
    required this.status,
    this.remarks,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      courseId: json['courseId'] as String,
      courseCode: json['courseCode'] as String,
      courseTitle: json['courseTitle'] as String,
      date: DateTime.parse(json['date'] as String),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AttendanceStatus.present,
      ),
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'courseId': courseId,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'date': date.toIso8601String(),
      'status': status.name,
      'remarks': remarks,
    };
  }
}

class SubjectAttendanceSummary {
  final String courseId;
  final String courseCode;
  final String courseTitle;
  final int attendedClasses;
  final int totalClasses;
  final int lateClasses;

  SubjectAttendanceSummary({
    required this.courseId,
    required this.courseCode,
    required this.courseTitle,
    required this.attendedClasses,
    required this.totalClasses,
    this.lateClasses = 0,
  });

  double get percentage =>
      totalClasses == 0 ? 100.0 : (attendedClasses / totalClasses) * 100.0;

  bool get isBelowThreshold =>
      percentage < AppConstants.attendanceWarningThreshold;
}
