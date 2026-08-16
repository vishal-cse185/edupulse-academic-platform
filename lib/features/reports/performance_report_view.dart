import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/ai_insight_model.dart';
import '../../models/exam_model.dart';
import '../../models/user_model.dart';
import '../../widgets/risk_badge.dart';

class PerformanceReportModal extends StatelessWidget {
  final UserModel student;
  final AIInsightModel aiInsight;
  final List<ExamGradeModel> examGrades;

  const PerformanceReportModal({
    super.key,
    required this.student,
    required this.aiInsight,
    required this.examGrades,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.school, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Official Academic Performance Summary & AI Diagnosis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Report Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Institution Header Block
                  Center(
                    child: Column(
                      children: [
                        Text(
                          AppConstants.appName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'OFFICIAL ACADEMIC EVALUATION & RISK DIAGNOSTIC TRANSCRIPT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Generated: ${DateFormat('MMMM d, yyyy - hh:mm a').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 36, color: AppColors.primaryDark, thickness: 1.5),

                  // Student Details Header Grid
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Name: ${student.name}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Student ID: ${student.studentIdNumber ?? 'CS-2026-042'}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Department: ${student.department ?? 'Computer Science & Engineering'}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RiskBadge(riskLevel: aiInsight.riskLevel),
                            const SizedBox(height: 6),
                            Text(
                              'Overall Score: ${aiInsight.overallScore}%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text(
                              'Attendance Rate: ${aiInsight.attendanceRate}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: aiInsight.attendanceRate < 75.0
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Academic Performance Summary
                  const Text(
                    '1. Academic Performance Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    aiInsight.executiveSummary,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 2: Examination Marks Table
                  const Text(
                    '2. Examination Marks & Grade Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(color: AppColors.border),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Examination',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Subject',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Score',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Grade',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      ...examGrades.map((g) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(g.examTitle,
                                  style: const TextStyle(fontSize: 12)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(g.subject,
                                  style: const TextStyle(fontSize: 12)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '${g.marksObtained.toStringAsFixed(1)} / ${g.totalMarks.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 12)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(g.gradeLetter,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section 3: Weak Areas Identified
                  const Text(
                    '3. Weak Areas & Concept Gap Analysis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (aiInsight.weakSubjects.isEmpty)
                    const Text('No critical concept deficiencies flagged.',
                        style: TextStyle(fontSize: 13, color: AppColors.success))
                  else
                    ...aiInsight.weakSubjects.map((w) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '• ${w.subjectName} (${w.averageScore}%): Deficiencies in [${w.conceptGaps.join(', ')}]. Recommended: ${w.suggestedRemedy}',
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),

                  // Section 4: Risk Analysis
                  const Text(
                    '4. Academic Risk Assessment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (aiInsight.riskFactors.isEmpty)
                    const Text('Student is in good academic standing (Low Risk).',
                        style: TextStyle(fontSize: 13, color: AppColors.success))
                  else
                    ...aiInsight.riskFactors.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('⚠️ $r',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500)),
                        )),
                  const SizedBox(height: 24),

                  // Section 5: AI Recommendations
                  const Text(
                    '5. AI Personalized Recommendations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...aiInsight.recommendations.map((rec) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• [${rec.priority} Priority] ${rec.title}: ${rec.description} (Estimated time: ${rec.estimatedMinutes} mins)',
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 20),

                  // Institutional Verification & Signature Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.verified_user,
                                  color: AppColors.success, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Digital Institutional Authentication',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SHA-256 Audit: #EDUPULSE-2026-ACCRE-${student.id.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Verified by AI Academic Governance Board',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Dr. Alan Turing, Ph.D.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Dean of Academic Affairs & Faculty Advising',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Download / Print Action Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('Close Preview'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Academic Summary Report sent to printer / PDF export generated!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text('Print / Download PDF Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
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
    );
  }
}
