import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/course_model.dart';
import '../../services/auth_service.dart';
import '../../services/course_service.dart';
import '../../widgets/course_card.dart';
import '../../widgets/public_footer.dart';
import '../../widgets/public_header.dart';
import '../../widgets/ai_study_tutor_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseService = Provider.of<CourseService>(context);
    final authService = Provider.of<AuthService>(context);
    final featuredCourses = courseService.featuredCourses;
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeHome),

            // 1. Institutional Hero Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: isDesktop ? 72 : 44,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Accreditation Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.verified,
                              color: Color(0xFF34D399), size: 15),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Accredited Academic Intelligence & Learning Standard 2026',
                              style: TextStyle(
                                color: Color(0xFFE2E8F0),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Headline
                    Text(
                      'Unified Education Management\n& Academic Learning Analytics',
                      style: TextStyle(
                        fontSize: isDesktop ? 46 : 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1.0,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 780),
                      child: Text(
                        'Empowering students, distinguished faculty, and academic deans with automated attendance tracking, multi-factor risk diagnostics, continuous assessment, and 24/7 interactive learning assistance.',
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          color: const Color(0xFF94A3B8),
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Quick Search & Action Buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, AppConstants.routeCourses),
                          icon: const Icon(Icons.explore_outlined, size: 18),
                          label: const Text('Explore Courses'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 16),
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => const AIStudyTutorModal(),
                            );
                          },
                          icon: const Icon(Icons.auto_awesome,
                              color: Color(0xFF818CF8), size: 18),
                          label: const Text('Launch Study Advisor',
                              style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF475569)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, AppConstants.routeUserAuth),
                          child: Text(
                            authService.isAuthenticated
                                ? 'Access Workspace Portal →'
                                : 'Sign In to Portal',
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Live Institutional Metrics Ribbon
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Wrap(
                        spacing: 36,
                        runSpacing: 16,
                        alignment: WrapAlignment.spaceAround,
                        children: [
                          _buildHeroMetric('14,500+', 'Enrolled Students'),
                          _buildHeroMetric('98.4%', 'Accreditation Compliance'),
                          _buildHeroMetric('< 48 hrs', 'Early Risk Intervention'),
                          _buildHeroMetric('24 / 7', 'Academic Study Support'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Announcements & Institutional Notices
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 20,
              ),
              color: const Color(0xFFF1F5F9),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'OFFICIAL NOTICE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Midterm Examination Schedule for Fall 2026 is published. Students with <75% attendance must review remedial intervention protocols with faculty.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Four Core Educational Pillars
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 48,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Autonomous Academic Architecture',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Engineered for comprehensive student tracking, teacher empowerment, and administrative compliance.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isDesktop ? 1.15 : 2.5,
                      children: [
                        _buildPillarCard(
                          icon: Icons.psychology_outlined,
                          title: 'Multi-Factor Learning Diagnostics',
                          desc:
                              'Evaluates 40% exams, 35% assignments, and 25% attendance to flag early attrition risks.',
                          color: AppColors.accent,
                        ),
                        _buildPillarCard(
                          icon: Icons.checklist_rounded,
                          title: 'Automated Code & Rubrics',
                          desc:
                              'Instant grading engine with detailed syntax, complexity, and conceptual feedback.',
                          color: AppColors.secondary,
                        ),
                        _buildPillarCard(
                          icon: Icons.calendar_month_outlined,
                          title: 'Attendance Compliance',
                          desc:
                              'Live accreditation threshold tracking with immediate warning alerts for rates <75%.',
                          color: AppColors.warning,
                        ),
                        _buildPillarCard(
                          icon: Icons.account_balance_outlined,
                          title: 'Executive Transcripts',
                          desc:
                              'Printable official academic evaluation transcripts with department bottleneck analytics.',
                          color: AppColors.success,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 4. Featured Courses Section
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
                              'Featured Academic Courses',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Accredited curriculum taught by distinguished university faculty',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, AppConstants.routeCourses),
                          icon: const Text('View All Offerings'),
                          label: const Icon(Icons.arrow_forward_rounded,
                              size: 16),
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

            // 5. Top Teachers / Faculty Showcase
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 48,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distinguished Faculty & Department Heads',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Academic mentors driving research and student success.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isDesktop)
                      Row(
                        children: [
                          Expanded(
                            child: _buildTeacherCard(
                              name: 'Dr. Alan Turing',
                              title: 'Professor & Head of Computing',
                              department: 'Computer Science & Engineering',
                              courses: 'CS301 (DSA), SE205 (Software Eng)',
                              rating: '4.9 ★ (120+ reviews)',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTeacherCard(
                              name: 'Dr. Ada Lovelace',
                              title: 'Lead AI Researcher & Faculty',
                              department: 'Artificial Intelligence & Data',
                              courses: 'AI402 (Deep Learning), DS104 (Stats)',
                              rating: '5.0 ★ (95+ reviews)',
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
                            department: 'Computer Science & Engineering',
                            courses: 'CS301 (DSA), SE205 (Software Eng)',
                            rating: '4.9 ★ (120+ reviews)',
                          ),
                          const SizedBox(height: 12),
                          _buildTeacherCard(
                            name: 'Dr. Ada Lovelace',
                            title: 'Lead AI Researcher & Faculty',
                            department: 'Artificial Intelligence & Data',
                            courses: 'AI402 (Deep Learning), DS104 (Stats)',
                            rating: '5.0 ★ (95+ reviews)',
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

  Widget _buildHeroMetric(String val, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPillarCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
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
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: color),
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
        ],
      ),
    );
  }

  Widget _buildTeacherCard({
    required String name,
    required String title,
    required String department,
    required String courses,
    required String rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary.withOpacity(0.08),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  department,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Active Courses: $courses',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
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
