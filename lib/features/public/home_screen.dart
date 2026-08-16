import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/course_model.dart';
import '../../services/course_service.dart';
import '../../widgets/course_card.dart';
import '../../widgets/public_footer.dart';
import '../../widgets/public_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseService = Provider.of<CourseService>(context);
    final featuredCourses = courseService.featuredCourses;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeHome),

            // Hero Banner Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 24,
                vertical: isDesktop ? 64 : 40,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A),
                    AppColors.primaryDark,
                    const Color(0xFF1E3A8A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF818CF8).withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.auto_awesome,
                              size: 14, color: Color(0xFF818CF8)),
                          SizedBox(width: 6),
                          Text(
                            'AI-Powered Academic Intelligence 2026',
                            style: TextStyle(
                              color: Color(0xFFC7D2FE),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Unified Education Management &\nPredictive Academic Intelligence',
                      style: TextStyle(
                        fontSize: isDesktop ? 42 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 750),
                      child: Text(
                        'Manage students, teachers, courses, attendance, and examinations with automated AI diagnostics for early risk detection and personalized study recommendations.',
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          color: const Color(0xFFCBD5E1),
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, AppConstants.routeCourses),
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('Explore Courses'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, AppConstants.routeUserAuth),
                          icon: const Icon(Icons.login, size: 18, color: Colors.white),
                          label: const Text('Sign In to Portal',
                              style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white70),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Announcements Section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 32,
              ),
              color: const Color(0xFFF1F5F9),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.campaign, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Latest Announcements',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...MockData.announcements.map((anc) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: anc.isUrgent
                                      ? AppColors.errorBg
                                      : AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  anc.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: anc.isUrgent
                                        ? AppColors.error
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      anc.title,
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      anc.content,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
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

            // AI Intelligence Feature Highlights
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 48,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    const Text(
                      'AI-Powered Academic Intelligence',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Proactive student risk assessment, weak concept discovery, and automated adaptive study plans.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : (MediaQuery.of(context).size.width > 550 ? 2 : 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.1 : 1.3,
                      children: [
                        _buildFeatureCard(
                          icon: Icons.psychology,
                          color: const Color(0xFF6366F1),
                          title: 'At-Risk Detection',
                          description:
                              'Identifies students at risk before exams based on attendance and submission metrics.',
                        ),
                        _buildFeatureCard(
                          icon: Icons.biotech,
                          color: AppColors.secondary,
                          title: 'Weak Topic Diagnostics',
                          description:
                              'Discovers precise concept gaps in dynamic programming, vector math, and algorithms.',
                        ),
                        _buildFeatureCard(
                          icon: Icons.auto_awesome,
                          color: const Color(0xFFF59E0B),
                          title: 'Personalized Study Plans',
                          description:
                              'Generates actionable daily study recommendations with estimated completion times.',
                        ),
                        _buildFeatureCard(
                          icon: Icons.insights,
                          color: AppColors.primary,
                          title: 'Executive Analytics',
                          description:
                              'Supplies cohort-level heatmaps and decision-support alerts to teachers and deans.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Featured Courses Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Featured Courses',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Top-rated courses taught by distinguished faculty',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, AppConstants.routeCourses),
                          icon: const Text('View All Courses'),
                          label: const Icon(Icons.arrow_forward, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 3 : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 280,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: featuredCourses.length,
                      itemBuilder: (context, index) {
                        final course = featuredCourses[index];
                        return CourseCard(
                          course: course,
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
            ),

            // Top Teachers Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 36,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distinguished Faculty & Instructors',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isDesktop)
                      Row(
                        children: [
                          Expanded(
                            child: _buildTeacherCard(
                              name: 'Dr. Alan Turing',
                              title: 'Professor & Head of Computing',
                              department: 'Computer Science',
                              courses: 'CS301, SE205',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTeacherCard(
                              name: 'Dr. Ada Lovelace',
                              title: 'Lead AI Researcher & Faculty',
                              department: 'Artificial Intelligence',
                              courses: 'AI402, DS104',
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildTeacherCard(
                            name: 'Dr. Alan Turing',
                            title: 'Professor & Head of Computing',
                            department: 'Computer Science',
                            courses: 'CS301, SE205',
                          ),
                          const SizedBox(height: 12),
                          _buildTeacherCard(
                            name: 'Dr. Ada Lovelace',
                            title: 'Lead AI Researcher & Faculty',
                            department: 'Artificial Intelligence',
                            courses: 'AI402, DS104',
                          ),
                        ],
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

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
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
            description,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard({
    required String name,
    required String title,
    required String department,
    required String courses,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              name.split(' ').last[0],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Department: $department • Courses: $courses',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
