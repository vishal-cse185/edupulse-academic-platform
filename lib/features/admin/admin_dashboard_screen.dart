import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/course_service.dart';
import '../../services/attendance_service.dart';
import '../../services/exam_service.dart';
import '../../services/assignment_service.dart';
import '../../services/ai_academic_engine.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/public_header.dart';
import 'admin_reports_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final courseService = Provider.of<CourseService>(context);
    final attService = Provider.of<AttendanceService>(context);
    final examService = Provider.of<ExamService>(context);
    final aiEngine = Provider.of<AIAcademicEngineService>(context);

    final admin = auth.currentUser ?? MockData.demoAdmin;

    final cohortAnalysis = aiEngine.generateClassCohortAnalysis(
      courseService.courses,
      examService.grades,
      attService.records,
    );

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeAdminDashboard),

            // Banner Bar
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
                          backgroundColor: AppColors.primaryDark.withOpacity(0.1),
                          child: const Icon(Icons.admin_panel_settings,
                              color: AppColors.primaryDark, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  admin.name,
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
                                    color: AppColors.primaryDark,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'ADMINISTRATOR',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${admin.department ?? 'Academic Affairs'} • System Oversight & Analytics',
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
                          context, AppConstants.routeAdminReports),
                      icon: const Icon(Icons.analytics_outlined, size: 16),
                      label: const Text('Institutional AI Reports'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
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
                      _buildTabBtn(context, 'Overview Dashboard', Icons.dashboard,
                          true, AppConstants.routeAdminDashboard),
                      _buildTabBtn(context, 'Manage Students & Faculty',
                          Icons.people, false, AppConstants.routeAdminUsers),
                      _buildTabBtn(context, 'Manage Courses & Classes',
                          Icons.menu_book, false, AppConstants.routeAdminCourses),
                      _buildTabBtn(context, 'Reports & Analytics',
                          Icons.assessment, false,
                          AppConstants.routeAdminReports),
                    ],
                  ),
                ),
              ),
            ),

            // Content Area
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
                    // System-wide metric cards
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : (MediaQuery.of(context).size.width > 550 ? 2 : 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.5 : 1.7,
                      children: [
                        StatCard(
                          title: 'Total Enrolled Students',
                          value: '${cohortAnalysis['totalStudents']}',
                          subtitle: '4 Academic Departments',
                          icon: Icons.school,
                          iconColor: AppColors.primary,
                          trendText: '+12%',
                        ),
                        StatCard(
                          title: 'Average Attendance',
                          value: '${cohortAnalysis['avgAttendance']}%',
                          subtitle: 'Accreditation minimum: 75%',
                          icon: Icons.calendar_month,
                          iconColor: AppColors.success,
                          trendText: 'Compliant',
                        ),
                        StatCard(
                          title: 'University GPA Average',
                          value: '3.42 / 4.0',
                          subtitle: 'Cohort Average: 78.6%',
                          icon: Icons.grade,
                          iconColor: AppColors.secondary,
                        ),
                        StatCard(
                          title: 'At-Risk Student Alerts',
                          value: '${cohortAnalysis['highRiskCount']}',
                          subtitle: 'Immediate review needed',
                          icon: Icons.warning_rounded,
                          iconColor: AppColors.error,
                          isTrendPositive: false,
                          trendText: 'Action Required',
                          onTap: () => Navigator.pushNamed(
                              context, AppConstants.routeAdminReports),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Institution-wide AI Risk Matrix & Interventions
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.hub_outlined,
                                      color: AppColors.primary, size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    'Institutional Risk Distribution & Trend Analysis',
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
                          const SizedBox(height: 20),

                          // Risk Segment Breakdown
                          Row(
                            children: [
                              _buildRiskSegment(
                                label: 'Low Risk (On Track)',
                                count: cohortAnalysis['lowRiskCount'],
                                percentage: '75.8%',
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 16),
                              _buildRiskSegment(
                                label: 'Moderate Risk (Watchlist)',
                                count: cohortAnalysis['mediumRiskCount'],
                                percentage: '17.7%',
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 16),
                              _buildRiskSegment(
                                label: 'High Risk (Intervention)',
                                count: cohortAnalysis['highRiskCount'],
                                percentage: '6.5%',
                                color: AppColors.error,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // AI Executive Interventions
                          const Text(
                            'AI Institutional Executive Recommendations:',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...(cohortAnalysis['recommendedInterventions']
                                  as List<String>)
                              .map((rec) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle_outline,
                                      size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      rec,
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

                    // Quick Navigation Hub
                    const Text(
                      'Administrative Management Modules',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAdminActionTile(
                            context,
                            title: 'Manage Students & Faculty',
                            desc:
                                'Create student profiles, manage faculty appointments, and update departments.',
                            icon: Icons.people_outline,
                            route: AppConstants.routeAdminUsers,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAdminActionTile(
                            context,
                            title: 'Manage Courses & Classes',
                            desc:
                                'Configure course catalog, assign syllabus modules, and schedule lecture halls.',
                            icon: Icons.menu_book,
                            route: AppConstants.routeAdminCourses,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAdminActionTile(
                            context,
                            title: 'Comparative Reports',
                            desc:
                                'Export accreditation performance summaries, weak area analysis, and CSV files.',
                            icon: Icons.assessment_outlined,
                            route: AppConstants.routeAdminReports,
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
    );
  }

  Widget _buildRiskSegment({
    required String label,
    required int count,
    required String percentage,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$count Students',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActionTile(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required String route,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, route),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              minimumSize: const Size(double.infinity, 38),
            ),
            child: const Text('Open Management Module',
                style: TextStyle(fontSize: 12)),
          ),
        ],
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
            color: isActive ? AppColors.primaryDark : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isActive ? AppColors.primaryDark : AppColors.border),
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
