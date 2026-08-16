import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'core/theme.dart';
import 'services/auth_service.dart';
import 'services/course_service.dart';
import 'services/attendance_service.dart';
import 'services/assignment_service.dart';
import 'services/exam_service.dart';
import 'services/ai_academic_engine.dart';
import 'services/report_service.dart';

// Public Pages
import 'features/public/home_screen.dart';
import 'features/public/courses_screen.dart';
import 'features/public/course_detail_screen.dart';
import 'features/public/contact_screen.dart';

// Auth Pages
import 'features/auth/user_login_screen.dart';
import 'features/admin/admin_login_screen.dart';

// Student Pages
import 'features/student/student_dashboard_screen.dart';
import 'features/student/student_progress_screen.dart';
import 'features/student/student_assignments_screen.dart';
import 'features/student/student_attendance_screen.dart';
import 'features/student/student_grades_screen.dart';

// Teacher Pages
import 'features/teacher/teacher_dashboard_screen.dart';
import 'features/teacher/teacher_attendance_screen.dart';
import 'features/teacher/teacher_assignments_screen.dart';
import 'features/teacher/teacher_exams_screen.dart';
import 'features/teacher/teacher_students_screen.dart';

// Admin Pages
import 'features/admin/admin_dashboard_screen.dart';
import 'features/admin/admin_manage_users_screen.dart';
import 'features/admin/admin_manage_courses_screen.dart';
import 'features/admin/admin_reports_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EduPulseApp());
}

class EduPulseApp extends StatelessWidget {
  const EduPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<CourseService>(create: (_) => CourseService()),
        ChangeNotifierProvider<AttendanceService>(
            create: (_) => AttendanceService()),
        ChangeNotifierProvider<AssignmentService>(
            create: (_) => AssignmentService()),
        ChangeNotifierProvider<ExamService>(create: (_) => ExamService()),
        ChangeNotifierProvider<AIAcademicEngineService>(
            create: (_) => AIAcademicEngineService()),
        ChangeNotifierProxyProvider<AIAcademicEngineService, ReportService>(
          create: (context) => ReportService(
            Provider.of<AIAcademicEngineService>(context, listen: false),
          ),
          update: (context, aiEngine, previous) => ReportService(aiEngine),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppConstants.routeHome,
        routes: {
          // Public Navigation
          AppConstants.routeHome: (context) => const HomeScreen(),
          AppConstants.routeCourses: (context) => const CoursesScreen(),
          AppConstants.routeCourseDetail: (context) =>
              const CourseDetailScreen(),
          AppConstants.routeContact: (context) => const ContactScreen(),

          // Auth
          AppConstants.routeUserAuth: (context) => const UserLoginScreen(),
          AppConstants.routeAdminLogin: (context) => const AdminLoginScreen(),

          // Student Area
          AppConstants.routeStudentDashboard: (context) =>
              const StudentDashboardScreen(),
          AppConstants.routeStudentCourses: (context) => const CoursesScreen(),
          AppConstants.routeStudentAssignments: (context) =>
              const StudentAssignmentsScreen(),
          AppConstants.routeStudentAttendance: (context) =>
              const StudentAttendanceScreen(),
          AppConstants.routeStudentGrades: (context) =>
              const StudentGradesScreen(),
          AppConstants.routeStudentProgress: (context) =>
              const StudentProgressScreen(),

          // Teacher Area
          AppConstants.routeTeacherDashboard: (context) =>
              const TeacherDashboardScreen(),
          AppConstants.routeTeacherAttendance: (context) =>
              const TeacherAttendanceScreen(),
          AppConstants.routeTeacherAssignments: (context) =>
              const TeacherAssignmentsScreen(),
          AppConstants.routeTeacherExams: (context) =>
              const TeacherExamsScreen(),
          AppConstants.routeTeacherStudents: (context) =>
              const TeacherStudentsScreen(),

          // Admin Area
          AppConstants.routeAdminDashboard: (context) =>
              const AdminDashboardScreen(),
          AppConstants.routeAdminUsers: (context) =>
              const AdminManageUsersScreen(),
          AppConstants.routeAdminCourses: (context) =>
              const AdminManageCoursesScreen(),
          AppConstants.routeAdminReports: (context) =>
              const AdminReportsScreen(),
        },
      ),
    );
  }
}
