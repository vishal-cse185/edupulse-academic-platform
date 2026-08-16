import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/user_model.dart';
import '../../services/attendance_service.dart';
import '../../services/exam_service.dart';
import '../../services/assignment_service.dart';
import '../../services/course_service.dart';
import '../../services/ai_academic_engine.dart';
import '../../widgets/risk_badge.dart';
import '../../widgets/public_header.dart';
import '../reports/performance_report_view.dart';

class TeacherStudentsScreen extends StatelessWidget {
  const TeacherStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attService = Provider.of<AttendanceService>(context);
    final examService = Provider.of<ExamService>(context);
    final asgService = Provider.of<AssignmentService>(context);
    final courseService = Provider.of<CourseService>(context);
    final aiEngine = Provider.of<AIAcademicEngineService>(context);

    final students = [
      MockData.demoStudent1,
      MockData.demoStudentAtRisk,
      MockData.demoStudentTop,
    ];

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(
                activeRoute: AppConstants.routeTeacherStudents),

            // Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 32,
              ),
              color: AppColors.primaryDark,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Student Monitoring & AI Risk Alerts',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Automated risk categorization, weak concept diagnostics, and early intervention triggers.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Class Roster Risk Profiles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...students.map((student) {
                      final attRecords =
                          attService.getAttendanceForStudent(student.id);
                      final submissions =
                          asgService.getSubmissionsForStudent(student.id);
                      final grades =
                          examService.getGradesForStudent(student.id);
                      final enrolled = courseService
                          .getCoursesForStudent(student.enrolledCourseIds);

                      final insight = aiEngine.analyzeStudentPerformance(
                        studentId: student.id,
                        studentName: student.name,
                        attendanceRecords: attRecords,
                        submissions: submissions,
                        examGrades: grades,
                        enrolledCourses: enrolled,
                      );

                      final isHighRisk = insight.riskLevel == RiskLevel.high;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: isHighRisk
                                            ? AppColors.errorBg
                                            : AppColors.primary
                                                .withOpacity(0.08),
                                        child: Text(
                                          student.name[0],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isHighRisk
                                                ? AppColors.error
                                                : AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            '${student.studentIdNumber ?? 'ID-2026'} • ${student.department ?? 'Computer Science'}',
                                            style: const TextStyle(
                                              fontSize: 12.5,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  RiskBadge(riskLevel: insight.riskLevel),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                insight.executiveSummary,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Quick Metrics
                              Row(
                                children: [
                                  Text(
                                    'Composite: ${insight.overallScore}% • Attendance: ${insight.attendanceRate}% • GPA: ${examService.calculateGpa(student.id)}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (ctx) =>
                                            PerformanceReportModal(
                                          student: student,
                                          aiInsight: insight,
                                          examGrades: grades,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.description_outlined,
                                        size: 16),
                                    label: const Text('View Academic Report'),
                                  ),
                                  if (isHighRisk) ...[
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Academic Counseling invitation sent to ${student.name}!'),
                                            backgroundColor: AppColors.primary,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.mail_outline,
                                          size: 16),
                                      label: const Text('Trigger Intervention'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.error,
                                      ),
                                    ),
                                  ],
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
}
