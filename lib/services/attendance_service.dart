import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/mock_data.dart';
import '../models/attendance_model.dart';
import '../models/course_model.dart';

class AttendanceService extends ChangeNotifier {
  List<AttendanceRecord> _records = [];

  List<AttendanceRecord> get records => _records;

  AttendanceService() {
    _records = [
      ...MockData.getStudent1Attendance(),
      ...MockData.getStudentAtRiskAttendance(),
    ];
  }

  List<AttendanceRecord> getAttendanceForStudent(String studentId) {
    return _records.where((r) => r.studentId == studentId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<AttendanceRecord> getCourseAttendanceRecords(String courseId) {
    return _records.where((r) => r.courseId == courseId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void markAttendance(AttendanceRecord record) {
    // Replace if exists for same student, course and date, else add
    _records.removeWhere((r) =>
        r.studentId == record.studentId &&
        r.courseId == record.courseId &&
        r.date.year == record.date.year &&
        r.date.month == record.date.month &&
        r.date.day == record.date.day);
    _records.add(record);
    notifyListeners();
  }

  void markBulkAttendance(List<AttendanceRecord> bulkRecords) {
    for (final r in bulkRecords) {
      _records.removeWhere((existing) =>
          existing.studentId == r.studentId &&
          existing.courseId == r.courseId &&
          existing.date.year == r.date.year &&
          existing.date.month == r.date.month &&
          existing.date.day == r.date.day);
      _records.add(r);
    }
    notifyListeners();
  }

  List<SubjectAttendanceSummary> getSubjectSummaries(
    String studentId,
    List<CourseModel> courses,
  ) {
    final studentRecords = getAttendanceForStudent(studentId);
    final List<SubjectAttendanceSummary> summaries = [];

    for (final course in courses) {
      final courseRecords =
          studentRecords.where((r) => r.courseId == course.id).toList();
      
      final total = courseRecords.length;
      final attended = courseRecords
          .where((r) =>
              r.status == AttendanceStatus.present ||
              r.status == AttendanceStatus.late)
          .length;
      final lateCount =
          courseRecords.where((r) => r.status == AttendanceStatus.late).length;

      // Provide realistic baseline if few records
      final totalClasses = total > 0 ? total : 20;
      final attendedClasses = total > 0
          ? attended
          : (studentId == 'std_002' ? 12 : 19);

      summaries.add(SubjectAttendanceSummary(
        courseId: course.id,
        courseCode: course.code,
        courseTitle: course.title,
        attendedClasses: attendedClasses,
        totalClasses: totalClasses,
        lateClasses: lateCount,
      ));
    }

    return summaries;
  }

  double getOverallAttendancePercentage(String studentId) {
    final studentRecords = getAttendanceForStudent(studentId);
    if (studentRecords.isEmpty) {
      return studentId == 'std_002' ? 62.5 : 94.0;
    }
    final attended = studentRecords
        .where((r) =>
            r.status == AttendanceStatus.present ||
            r.status == AttendanceStatus.late)
        .length;
    return (attended / studentRecords.length) * 100.0;
  }
}
