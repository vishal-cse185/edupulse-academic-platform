enum UserRole {
  student,
  teacher,
  admin,
}

enum RiskLevel {
  low,
  medium,
  high,
}

enum AttendanceStatus {
  present,
  absent,
  late,
}

enum AssignmentStatus {
  pending,
  submitted,
  graded,
  overdue,
}

class AppConstants {
  static const String appName = 'EduPulse';
  static const String appTagline = 'AI-Powered Education Management & Academic Intelligence';
  
  // Route Names
  static const String routeHome = '/';
  static const String routeCourses = '/courses';
  static const String routeCourseDetail = '/course-detail';
  static const String routeContact = '/contact';
  
  static const String routeUserAuth = '/auth';
  static const String routeAdminLogin = '/admin-login';
  
  // Student Routes
  static const String routeStudentDashboard = '/student/dashboard';
  static const String routeStudentCourses = '/student/courses';
  static const String routeStudentAssignments = '/student/assignments';
  static const String routeStudentAttendance = '/student/attendance';
  static const String routeStudentGrades = '/student/grades';
  static const String routeStudentProgress = '/student/progress';
  
  // Teacher Routes
  static const String routeTeacherDashboard = '/teacher/dashboard';
  static const String routeTeacherAttendance = '/teacher/attendance';
  static const String routeTeacherAssignments = '/teacher/assignments';
  static const String routeTeacherExams = '/teacher/exams';
  static const String routeTeacherStudents = '/teacher/students';
  
  // Admin Routes
  static const String routeAdminDashboard = '/admin/dashboard';
  static const String routeAdminUsers = '/admin/users';
  static const String routeAdminCourses = '/admin/courses';
  static const String routeAdminReports = '/admin/reports';
  
  // Categories
  static const List<String> courseCategories = [
    'All',
    'Computer Science',
    'Mathematics',
    'Physics',
    'Data Science',
    'Artificial Intelligence',
    'Software Engineering',
  ];

  // Default Thresholds
  static const double attendanceWarningThreshold = 75.0;
  static const double passingGradeThreshold = 60.0;
  static const double highRiskGradeThreshold = 50.0;
}
