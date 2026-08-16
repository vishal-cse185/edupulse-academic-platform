import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';

class PublicFooter extends StatelessWidget {
  const PublicFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Container(
      color: AppColors.primaryDark,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 20,
        vertical: 36,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 32,
            runSpacing: 24,
            children: [
              // Column 1: Brand & Tagline
              SizedBox(
                width: isDesktop ? 320 : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school_rounded,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'EduPulse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Comprehensive Education Management & Academic Intelligence platform providing predictive learning diagnostics and institutional analytics.',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Column 2: Quick Links
              SizedBox(
                width: isDesktop ? 180 : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Links',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _footerLink(
                        context, 'Course Catalog', AppConstants.routeCourses),
                    _footerLink(
                        context, 'Student Portal', AppConstants.routeUserAuth),
                    _footerLink(context, 'Teacher Workspace',
                        AppConstants.routeUserAuth),
                    _footerLink(context, 'Admin Analytics',
                        AppConstants.routeAdminLogin),
                  ],
                ),
              ),

              // Column 3: Capabilities
              SizedBox(
                width: isDesktop ? 220 : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Core Capabilities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('• Academic Risk Detection',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            height: 1.6)),
                    Text('• Weak Concept Diagnosis',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            height: 1.6)),
                    Text('• Personalized Study Planner',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            height: 1.6)),
                    Text('• Multi-factor Analytics',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            height: 1.6)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 36, color: Color(0xFF334155)),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: const [
              Text(
                '© 2026 EduPulse. Academic Management Platform - All Rights Reserved.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
              ),
              Text(
                'National Accreditation & Academic Governance Standards',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}
