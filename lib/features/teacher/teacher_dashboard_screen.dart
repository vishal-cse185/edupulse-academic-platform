import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/course_service.dart';
import '../../services/assignment_service.dart';
import '../../services/exam_service.dart';
import '../../services/attendance_service.dart';
import '../../services/ai_academic_engine.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/public_header.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final courseService = Provider.of<CourseService>(context);
    final asgService = Provider.of<AssignmentService>(context);
    final examService = Provider.of<ExamService>(context);
    final attendanceService = Provider.of<AttendanceService>(context);
    final aiEngine = Provider.of<AIAcademicEngineService>(context);

    final teacher = auth.currentUser ?? MockData.demoTeacher1;
    final teachingCourses =
        courseService.getCoursesForTeacher(teacher.id);

    final cohortAnalysis = aiEngine.generateClassCohortAnalysis(
      courseService.courses,
      examService.grades,
      attendanceService.records,
    );

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeTeacherDashboard),

            // Profile Header Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 24,
              ),
              color: Colors.white,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.secondary.withOpacity(0.15),
                          child: Text(
                            teacher.name.isNotEmpty ? teacher.name.split(' ').last[0] : 'T',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  teacher.name,
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
                                    color: AppColors.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'FACULTY',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${teacher.teacherTitle ?? 'Professor'} • ${teacher.department ?? 'Computer Science'}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                          context, AppConstants.routeTeacherAttendance),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Mark Class Attendance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Navigation Tabs
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
                          AppConstants.routeTeacherDashboard),
                      _buildTabBtn(context, 'Attendance Ledger', Icons.fact_check,
                          false, AppConstants.routeTeacherAttendance),
                      _buildTabBtn(context, 'Assignments & Grading',
                          Icons.assignment, false,
                          AppConstants.routeTeacherAssignments),
                      _buildTabBtn(context, 'Exams & Marks', Icons.military_tech,
                          false, AppConstants.routeTeacherExams),
                      _buildTabBtn(context, 'Student Risk Monitor', Icons.people,
                          false, AppConstants.routeTeacherStudents),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
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
                    // Stats Metric Cards
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : (MediaQuery.of(context).size.width > 550 ? 2 : 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.5 : 1.7,
                      children: [
                        StatCard(
                          title: 'Active Teaching Courses',
                          value: '${teachingCourses.isNotEmpty ? teachingCourses.length : 2}',
                          subtitle: 'Current Semester',
                          icon: Icons.menu_book,
                          iconColor: AppColors.primary,
                        ),
                        StatCard(
                          title: 'Total Enrolled Students',
                          value: '84',
                          subtitle: 'Across all sections',
                          icon: Icons.people_alt_outlined,
                          iconColor: AppColors.secondary,
                        ),
                        StatCard(
                          title: 'Submissions to Evaluate',
                          value: '${asgService.submissions.length}',
                          subtitle: 'AI pre-graded',
                          icon: Icons.assignment_turned_in,
                          iconColor: const Color(0xFFF59E0B),
                          onTap: () => Navigator.pushNamed(
                              context, AppConstants.routeTeacherAssignments),
                        ),
                        StatCard(
                          title: 'At-Risk Students',
                          value: '${cohortAnalysis['highRiskCount']}',
                          subtitle: 'Require intervention',
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.error,
                          isTrendPositive: false,
                          trendText: 'Alert',
                          onTap: () => Navigator.pushNamed(
                              context, AppConstants.routeTeacherStudents),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Cohort AI Intelligence & Decision Support Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome,
                                      color: Color(0xFF4F46E5), size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    'AI Cohort Diagnostic & Teacher Decision Support',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'AI analysis of recent midterm exams and assignment submissions highlights critical concept bottlenecks in your classes.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Struggling Topics
                          const Text(
                            'Class-Wide Concept Bottlenecks (Most Missed Topics):',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: (cohortAnalysis['topStrugglingTopics']
                                    as List<String>)
                                .map((topic) {
                              return Chip(
                                label: Text(topic,
                                    style: const TextStyle(fontSize: 12)),
                                backgroundColor: const Color(0xFFFEF2F2),
                                side: const BorderSide(
                                    color: Color(0xFFFCA5A5)),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Recommended Actions
                          const Text(
                            'Recommended Teaching Interventions:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...(cohortAnalysis['recommendedInterventions']
                                  as List<String>)
                              .map((action) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.bolt,
                                      size: 16, color: Color(0xFF6366F1)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      action,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Teaching Courses Grid
                    const Text(
                      'Assigned Teaching Courses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...teachingCourses.map((course) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          course.code,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        course.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${course.schedule} • ${course.room} • ${course.enrolledStudentCount} Enrolled Students',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppConstants.routeTeacherAttendance),
                                    child: const Text('Attendance'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppConstants.routeTeacherAssignments),
                                    child: const Text('Assignments'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            color: isActive ? AppColors.secondary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isActive ? AppColors.secondary : AppColors.border),
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
