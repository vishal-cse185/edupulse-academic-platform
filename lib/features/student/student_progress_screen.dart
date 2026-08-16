import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/ai_insight_model.dart';
import '../../services/auth_service.dart';
import '../../services/course_service.dart';
import '../../services/attendance_service.dart';
import '../../services/assignment_service.dart';
import '../../services/exam_service.dart';
import '../../services/ai_academic_engine.dart';
import '../../widgets/risk_badge.dart';
import '../../widgets/public_header.dart';
import '../reports/performance_report_view.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  final Map<String, bool> _completedRecommendations = {};

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final courseService = Provider.of<CourseService>(context);
    final attendanceService = Provider.of<AttendanceService>(context);
    final assignmentService = Provider.of<AssignmentService>(context);
    final examService = Provider.of<ExamService>(context);
    final aiEngine = Provider.of<AIAcademicEngineService>(context);

    final student = auth.currentUser!;
    final enrolledCourses =
        courseService.getCoursesForStudent(student.enrolledCourseIds);
    final attendanceRecords =
        attendanceService.getAttendanceForStudent(student.id);
    final submissions = assignmentService.getSubmissionsForStudent(student.id);
    final examGrades = examService.getGradesForStudent(student.id);

    final aiInsight = aiEngine.analyzeStudentPerformance(
      studentId: student.id,
      studentName: student.name,
      attendanceRecords: attendanceRecords,
      submissions: submissions,
      examGrades: examGrades,
      enrolledCourses: enrolledCourses,
    );

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeStudentProgress),

            // Banner Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 36,
              ),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'My AI Progress & Academic Intelligence',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            RiskBadge(riskLevel: aiInsight.riskLevel),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Continuous multi-criteria diagnosis for ${student.name} (${student.studentIdNumber ?? 'ID-2026'})',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => PerformanceReportModal(
                            student: student,
                            aiInsight: aiInsight,
                            examGrades: examGrades,
                          ),
                        );
                      },
                      icon: const Icon(Icons.print, size: 16),
                      label: const Text('Download / Print Summary'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Area
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
                    // Diagnostic Overview Card
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
                          const Text(
                            'Performance Overview & Risk Diagnostic',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            aiInsight.executiveSummary,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Trigger Factors Alert
                          if (aiInsight.riskFactors.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.errorBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.error.withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.warning_amber_rounded,
                                          color: AppColors.error, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Academic Risk Trigger Factors Identified:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...aiInsight.riskFactors.map((factor) =>
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4, left: 26),
                                        child: Text(
                                          '• $factor',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: Color(0xFF991B1B),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Progress Indicators
                          Row(
                            children: [
                              _buildProgressGauge(
                                label: 'Composite Score',
                                value: aiInsight.overallScore,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 24),
                              _buildProgressGauge(
                                label: 'Attendance Rate',
                                value: aiInsight.attendanceRate,
                                color: aiInsight.attendanceRate < 75.0
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Weak Subjects & Concept Gaps
                    const Text(
                      'Identified Weak Subjects & Technical Concept Gaps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (aiInsight.weakSubjects.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.verified,
                                color: AppColors.success, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'No critical subject deficiencies detected! Excellent academic trajectory.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...aiInsight.weakSubjects.map((weak) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      weak.subjectName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.errorBg,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Average: ${weak.averageScore}%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Specific Concept Deficiencies:',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: weak.conceptGaps.map((gap) {
                                    return Chip(
                                      label: Text(gap,
                                          style:
                                              const TextStyle(fontSize: 12)),
                                      backgroundColor:
                                          const Color(0xFFFEF2F2),
                                      side: const BorderSide(
                                          color: Color(0xFFFCA5A5)),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.lightbulb_outline,
                                        size: 16,
                                        color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Recommended Remedy: ${weak.suggestedRemedy}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 28),

                    // Personalized AI Study Plan (Action Checklist)
                    const Text(
                      'Personalized AI Study Recommendations & Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...aiInsight.recommendations.map((rec) {
                      final isDone = _completedRecommendations[rec.id] ?? false;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CheckboxListTile(
                          value: isDone,
                          onChanged: (val) {
                            setState(() {
                              _completedRecommendations[rec.id] = val ?? false;
                            });
                          },
                          title: Row(
                            children: [
                              Text(
                                rec.title,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isDone
                                      ? AppColors.textMuted
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: rec.priority == 'High'
                                      ? AppColors.errorBg
                                      : AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${rec.priority} Priority • ~${rec.estimatedMinutes}m',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: rec.priority == 'High'
                                        ? AppColors.error
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              rec.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDone
                                    ? AppColors.textMuted
                                    : AppColors.textSecondary,
                              ),
                            ),
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

  Widget _buildProgressGauge({
    required String label,
    required double value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (value / 100).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}
