import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/course_service.dart';
import '../../services/attendance_service.dart';
import '../../services/assignment_service.dart';
import '../../services/exam_service.dart';
import '../../services/ai_academic_engine.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/course_card.dart';
import '../../widgets/public_header.dart';
import '../../widgets/ai_study_tutor_modal.dart';
import '../../widgets/gpa_simulator_modal.dart';
import '../reports/performance_report_view.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final courseService = Provider.of<CourseService>(context);
    final attendanceService = Provider.of<AttendanceService>(context);
    final assignmentService = Provider.of<AssignmentService>(context);
    final examService = Provider.of<ExamService>(context);
    final aiEngine = Provider.of<AIAcademicEngineService>(context);

    final student = auth.currentUser ??
        UserModel(
          id: 'std_001',
          name: 'Alex Johnson',
          email: 'student@edupulse.ai',
          role: UserRole.student,
          department: 'Computer Science',
          studentIdNumber: 'CS-2026-042',
          enrolledCourseIds: ['crs_001', 'crs_002', 'crs_003'],
        );

    final enrolledCourses =
        courseService.getCoursesForStudent(student.enrolledCourseIds);
    final attendanceRecords =
        attendanceService.getAttendanceForStudent(student.id);
    final submissions = assignmentService.getSubmissionsForStudent(student.id);
    final examGrades = examService.getGradesForStudent(student.id);
    final studentAssignments =
        assignmentService.getAssignmentsForStudent(student.enrolledCourseIds);

    // Real-time AI Analysis
    final aiInsight = aiEngine.analyzeStudentPerformance(
      studentId: student.id,
      studentName: student.name,
      attendanceRecords: attendanceRecords,
      submissions: submissions,
      examGrades: examGrades,
      enrolledCourses: enrolledCourses,
    );

    final gpa = examService.calculateGpa(student.id);
    final attendancePct =
        attendanceService.getOverallAttendancePercentage(student.id);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeStudentDashboard),

            // Top Profile Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 24,
              ),
              color: Colors.white,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            student.name.isNotEmpty ? student.name[0] : 'S',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  student.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    student.studentIdNumber ?? 'CS-2026',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${student.department ?? 'Computer Science'} • Student Workspace',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => GPASimulatorModal(
                                currentAttendance: attendancePct,
                                currentGpa: gpa,
                              ),
                            );
                          },
                          icon: const Icon(Icons.tune, size: 15),
                          label: const Text('GPA Simulator'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppConstants.routeStudentProgress);
                          },
                          icon: const Icon(Icons.insights, size: 15),
                          label: const Text('Academic Progress Plan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Navigation Tab Bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 12,
              ),
              color: const Color(0xFFF8FAFC),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTabBtn(context, 'Dashboard', Icons.dashboard, true,
                          AppConstants.routeStudentDashboard),
                      _buildTabBtn(context, 'My Progress', Icons.trending_up,
                          false, AppConstants.routeStudentProgress),
                      _buildTabBtn(context, 'Assignments', Icons.assignment,
                          false, AppConstants.routeStudentAssignments),
                      _buildTabBtn(context, 'Attendance', Icons.calendar_month,
                          false, AppConstants.routeStudentAttendance),
                      _buildTabBtn(context, 'Grades & GPA', Icons.grade, false,
                          AppConstants.routeStudentGrades),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content Area
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 28,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Metrics Row
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : (MediaQuery.of(context).size.width > 550 ? 2 : 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.5 : 1.7,
                      children: [
                        StatCard(
                          title: 'Overall Attendance',
                          value: '${attendancePct.toStringAsFixed(1)}%',
                          subtitle: attendancePct < 75.0
                              ? '⚠️ Below 75% Requirement'
                              : 'Good standing',
                          icon: Icons.calendar_today,
                          iconColor: attendancePct < 75.0
                              ? AppColors.error
                              : AppColors.success,
                          trendText: attendancePct < 75.0 ? 'At Risk' : '+2.4%',
                          isTrendPositive: attendancePct >= 75.0,
                          onTap: () => Navigator.pushNamed(
                              context, AppConstants.routeStudentAttendance),
                        ),
                        StatCard(
                          title: 'Cumulative GPA',
                          value: '$gpa / 4.0',
                          subtitle: 'Academic standing: A-',
                          icon: Icons.school,
                          iconColor: AppColors.primary,
                          trendText: '+0.15',
                          onTap: () => Navigator.pushNamed(
                              context, AppConstants.routeStudentGrades),
                        ),
                        StatCard(
                          title: 'Enrolled Courses',
                          value: '${enrolledCourses.length}',
                          subtitle: '11 Total Credits',
                          icon: Icons.menu_book,
                          iconColor: AppColors.secondary,
                        ),
                        StatCard(
                          title: 'Pending Assignments',
                          value: '${studentAssignments.length - submissions.length}',
                          subtitle: 'Due this week',
                          icon: Icons.assignment_late_outlined,
                          iconColor: const Color(0xFFF59E0B),
                          onTap: () => Navigator.pushNamed(
                              context, AppConstants.routeStudentAssignments),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // AI Insight Banner Card
                    AIInsightCard(
                      insight: aiInsight,
                      onViewDetails: () => Navigator.pushNamed(
                          context, AppConstants.routeStudentProgress),
                    ),
                    const SizedBox(height: 32),

                    // Courses & Upcoming Tasks Grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: My Enrolled Courses
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'My Enrolled Courses',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, AppConstants.routeCourses),
                                    child: const Text('Browse More Courses'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktop ? 2 : 1,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  mainAxisExtent: 260,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: enrolledCourses.length,
                                itemBuilder: (context, index) {
                                  final course = enrolledCourses[index];
                                  return CourseCard(
                                    course: course,
                                    isEnrolled: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppConstants.routeCourseDetail,
                                        arguments: course,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        if (isDesktop) const SizedBox(width: 28),

                        // Right: Pending Assignments & Report Generator Action
                        if (isDesktop)
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Assignments & Due Dates',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...studentAssignments.map((asg) {
                                  final isSubmitted = submissions.any(
                                      (s) => s.assignmentId == asg.id);
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: isSubmitted
                                                      ? AppColors.successBg
                                                      : const Color(0xFFFEF3C7),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  isSubmitted
                                                      ? 'SUBMITTED'
                                                      : 'PENDING',
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: isSubmitted
                                                        ? AppColors.success
                                                        : const Color(0xFFD97706),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${asg.maxScore} Pts',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            asg.title,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            asg.courseTitle,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 16),

                                // Quick Report Export CTA
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.summarize,
                                              color: Colors.white, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Academic Performance Summary',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Generate your official transcript summary with learning diagnostics and academic risk assessment.',
                                        style: TextStyle(
                                          color: Color(0xFFE2E8F0),
                                          fontSize: 12,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (ctx) =>
                                                PerformanceReportModal(
                                              student: student,
                                              aiInsight: aiInsight,
                                              examGrades: examGrades,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: AppColors.primary,
                                        ),
                                        child: const Text(
                                            'View & Print Full Report'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const AIStudyTutorModal(),
          );
        },
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text('Study Advisor',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4F46E5),
      ),
    );
  }

  Widget _buildTabBtn(BuildContext context, String label, IconData icon,
      bool isActive, String route) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          if (!isActive) Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isActive ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 16,
                  color: isActive ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
