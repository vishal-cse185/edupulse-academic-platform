import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/course_model.dart';
import '../../services/course_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/public_footer.dart';
import '../../widgets/public_header.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel? course;

  const CourseDetailScreen({super.key, this.course});

  @override
  Widget build(BuildContext context) {
    final effectiveCourse = course ??
        (ModalRoute.of(context)?.settings.arguments as CourseModel?) ??
        MockData.initialCourses.first;

    final authService = Provider.of<AuthService>(context);
    final courseService = Provider.of<CourseService>(context);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final isEnrolled = authService.currentUser?.enrolledCourseIds
            .contains(effectiveCourse.id) ??
        false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeCourses),

            // Header Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 24,
                vertical: 40,
              ),
              color: AppColors.primaryDark,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            effectiveCourse.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          effectiveCourse.code,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      effectiveCourse.title,
                      style: TextStyle(
                        fontSize: isDesktop ? 34 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      effectiveCourse.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFFCBD5E1),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        _buildInfoTag(
                          icon: Icons.person_outline,
                          text: effectiveCourse.teacherName,
                        ),
                        _buildInfoTag(
                          icon: Icons.calendar_today_outlined,
                          text: effectiveCourse.schedule,
                        ),
                        _buildInfoTag(
                          icon: Icons.room_outlined,
                          text: effectiveCourse.room,
                        ),
                        _buildInfoTag(
                          icon: Icons.star_rounded,
                          text: '${effectiveCourse.rating} Rating',
                          color: const Color(0xFFF59E0B),
                        ),
                        _buildInfoTag(
                          icon: Icons.workspace_premium_outlined,
                          text: '${effectiveCourse.credits} Credits',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Content Body (Syllabus & Info)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 40,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Main Column: Syllabus & Learning Outcomes
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Learning Objectives & Outcomes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...effectiveCourse.learningOutcomes.map((outcome) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle,
                                      size: 18, color: AppColors.secondary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      outcome,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Divider(height: 48, color: AppColors.divider),

                          const Text(
                            'Course Syllabus & Weekly Modules',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...effectiveCourse.syllabus.map((item) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: ExpansionTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'W${item.weekNumber}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Text(
                                  item.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Covered Topics:',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: item.topics.map((t) {
                                            return Chip(
                                              label: Text(t,
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                              backgroundColor:
                                                  const Color(0xFFF1F5F9),
                                              side: BorderSide.none,
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    if (isDesktop) const SizedBox(width: 36),

                    // Right Sidebar: Enrollment & Instructor
                    if (isDesktop)
                      Expanded(
                        child: Column(
                          children: [
                            // Enrollment Action Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Enrollment Status',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${effectiveCourse.enrolledStudentCount} Active Students currently enrolled',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (isEnrolled)
                                    ElevatedButton.icon(
                                      onPressed: () => Navigator.pushNamed(
                                          context,
                                          AppConstants.routeStudentDashboard),
                                      icon: const Icon(
                                          Icons.dashboard_outlined,
                                          size: 18),
                                      label: const Text('Go to Student Workspace'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                      ),
                                    )
                                  else
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        courseService
                                            .enrollStudent(effectiveCourse.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Enrolled in ${effectiveCourse.title}!'),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.school, size: 18),
                                      label: const Text('Enroll in Course'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Instructor Profile Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Course Faculty',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor:
                                            AppColors.primary.withOpacity(0.1),
                                        child: Text(
                                          effectiveCourse.teacherName[0],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              effectiveCourse.teacherName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              effectiveCourse.teacherTitle ??
                                                  'Faculty Instructor',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.secondary,
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
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const PublicFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color ?? const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color ?? const Color(0xFFE2E8F0),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
