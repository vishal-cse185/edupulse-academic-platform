import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../services/auth_service.dart';

class PublicHeader extends StatelessWidget {
  final String activeRoute;

  const PublicHeader({
    super.key,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppConstants.routeHome),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'EduPulse',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Academic Management Portal',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Navigation Links
          if (isDesktop)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavLink(context, 'Home', AppConstants.routeHome),
                const SizedBox(width: 4),
                _buildNavLink(context, 'Courses', AppConstants.routeCourses),
                const SizedBox(width: 4),
                _buildNavLink(
                    context, 'Contact & Support', AppConstants.routeContact),
              ],
            ),

          // Role Switcher / Auth Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fast Demo Switcher for AI Evaluation
              PopupMenuButton<String>(
                tooltip: 'Fast Switch Demo Role',
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.swap_horiz,
                          size: 14, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        'Demo: ${authService.currentUser?.role.name.toUpperCase() ?? 'LOGIN'}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'student',
                    child: Text('👨‍🎓 Student Demo (Alex - On Track)'),
                  ),
                  const PopupMenuItem(
                    value: 'student_risk',
                    child: Text('⚠️ Student Demo (David - At Risk <75%)'),
                  ),
                  const PopupMenuItem(
                    value: 'teacher',
                    child: Text('👩‍🏫 Teacher Demo (Dr. Alan Turing)'),
                  ),
                  const PopupMenuItem(
                    value: 'admin',
                    child: Text('🛡️ Admin Demo (Dean Eleanor)'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'student') {
                    authService.loginAsStudent(isAtRisk: false);
                    Navigator.pushNamed(
                        context, AppConstants.routeStudentDashboard);
                  } else if (value == 'student_risk') {
                    authService.loginAsStudent(isAtRisk: true);
                    Navigator.pushNamed(
                        context, AppConstants.routeStudentDashboard);
                  } else if (value == 'teacher') {
                    authService.loginAsTeacher();
                    Navigator.pushNamed(
                        context, AppConstants.routeTeacherDashboard);
                  } else if (value == 'admin') {
                    authService.loginAsAdmin();
                    Navigator.pushNamed(
                        context, AppConstants.routeAdminDashboard);
                  }
                },
              ),
              const SizedBox(width: 8),

              // Portal Access Button
              if (authService.isAuthenticated)
                ElevatedButton(
                  onPressed: () {
                    if (authService.currentRole == UserRole.student) {
                      Navigator.pushNamed(
                          context, AppConstants.routeStudentDashboard);
                    } else if (authService.currentRole == UserRole.teacher) {
                      Navigator.pushNamed(
                          context, AppConstants.routeTeacherDashboard);
                    } else {
                      Navigator.pushNamed(
                          context, AppConstants.routeAdminDashboard);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Dashboard'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppConstants.routeUserAuth);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Sign In'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(BuildContext context, String title, String route) {
    final isActive = activeRoute == route;
    return TextButton(
      onPressed: () {
        if (!isActive) Navigator.pushNamed(context, route);
      },
      style: TextButton.styleFrom(
        foregroundColor:
            isActive ? AppColors.primary : AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
