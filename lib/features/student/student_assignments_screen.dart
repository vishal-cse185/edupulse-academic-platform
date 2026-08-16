import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/assignment_model.dart';
import '../../services/auth_service.dart';
import '../../services/assignment_service.dart';
import '../../widgets/public_header.dart';

class StudentAssignmentsScreen extends StatefulWidget {
  const StudentAssignmentsScreen({super.key});

  @override
  State<StudentAssignmentsScreen> createState() =>
      _StudentAssignmentsScreenState();
}

class _StudentAssignmentsScreenState extends State<StudentAssignmentsScreen> {
  final _submissionController = TextEditingController();

  @override
  void dispose() {
    _submissionController.dispose();
    super.dispose();
  }

  void _showSubmitDialog(AssignmentModel assignment) {
    _submissionController.text =
        'https://github.com/student/solution-${assignment.courseId.toLowerCase()}\nImplemented algorithm with O(log N) runtime efficiency and full test suite.';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Submit: ${assignment.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course: ${assignment.courseTitle} • Max Score: ${assignment.maxScore} pts',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _submissionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Solution Text or Repository URL',
                hintText: 'Paste github link or code solution...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome, size: 16, color: AppColors.accent),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'AI Academic Evaluator will automatically analyze code quality & rubric criteria on submission.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final auth = Provider.of<AuthService>(context, listen: false);
              final asgService =
                  Provider.of<AssignmentService>(context, listen: false);
              final student = auth.currentUser!;

              Navigator.pop(ctx);
              final sub = await asgService.submitAssignment(
                assignmentId: assignment.id,
                studentId: student.id,
                studentName: student.name,
                submissionContent: _submissionController.text,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Assignment Submitted! AI Score: ${sub.score ?? 85}/100'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Submit Solution'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final asgService = Provider.of<AssignmentService>(context);
    final student = auth.currentUser!;

    final assignments =
        asgService.getAssignmentsForStudent(student.enrolledCourseIds);
    final submissions = asgService.getSubmissionsForStudent(student.id);

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(
                activeRoute: AppConstants.routeStudentAssignments),

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
                      'Assignments & AI Automated Feedback',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Submit lab exercises, view automated code diagnostics, and track teacher evaluations.',
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
                    ...assignments.map((asg) {
                      final submission = asgService.getSubmission(
                          asg.id, student.id);
                      final isSubmitted = submission != null;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Course & Status Badge
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      asg.courseTitle,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSubmitted
                                          ? AppColors.successBg
                                          : const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isSubmitted
                                          ? 'STATUS: SUBMITTED'
                                          : 'STATUS: PENDING',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isSubmitted
                                            ? AppColors.success
                                            : const Color(0xFFD97706),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Title & Description
                              Text(
                                asg.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                asg.description,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Rubric Breakdown
                              if (asg.rubricCriteria.isNotEmpty) ...[
                                const Text(
                                  'Grading Rubric Criteria:',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...asg.rubricCriteria.map((r) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2),
                                      child: Text(
                                        '• $r',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    )),
                                const SizedBox(height: 12),
                              ],

                              // AI Feedback Section if submitted
                              if (isSubmitted &&
                                  submission.aiFeedback != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xFF86EFAC)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.auto_awesome,
                                                  size: 16,
                                                  color: AppColors.success),
                                              SizedBox(width: 6),
                                              Text(
                                                'AI Automated Evaluation:',
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.success,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (submission.score != null)
                                            Text(
                                              'Score: ${submission.score!.toStringAsFixed(1)} / ${asg.maxScore}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryDark,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        submission.aiFeedback!,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.textPrimary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // Action Bar
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Max Score: ${asg.maxScore} pts',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _showSubmitDialog(asg),
                                    icon: Icon(
                                      isSubmitted
                                          ? Icons.replay
                                          : Icons.upload_file,
                                      size: 16,
                                    ),
                                    label: Text(isSubmitted
                                        ? 'Resubmit Solution'
                                        : 'Submit Solution'),
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
}
