import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/assignment_model.dart';
import '../../services/assignment_service.dart';
import '../../services/course_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/public_header.dart';

class TeacherAssignmentsScreen extends StatefulWidget {
  const TeacherAssignmentsScreen({super.key});

  @override
  State<TeacherAssignmentsScreen> createState() =>
      _TeacherAssignmentsScreenState();
}

class _TeacherAssignmentsScreenState extends State<TeacherAssignmentsScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _maxScoreController = TextEditingController(text: '100');
  String _selectedCourseId = 'crs_001';

  final _gradeScoreController = TextEditingController();
  final _teacherFeedbackController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _maxScoreController.dispose();
    _gradeScoreController.dispose();
    _teacherFeedbackController.dispose();
    super.dispose();
  }

  void _showCreateAssignmentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Assignment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Assignment Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description & Instructions',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _maxScoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Max Score'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final asgService =
                  Provider.of<AssignmentService>(context, listen: false);
              final auth = Provider.of<AuthService>(context, listen: false);
              final courseService =
                  Provider.of<CourseService>(context, listen: false);

              final course =
                  courseService.getCourseById(_selectedCourseId) ??
                      MockData.initialCourses.first;

              asgService.createAssignment(
                AssignmentModel(
                  id: 'asg_${DateTime.now().millisecondsSinceEpoch}',
                  courseId: course.id,
                  courseTitle: course.title,
                  teacherId: auth.currentUser?.id ?? 'tch_001',
                  title: _titleController.text.isNotEmpty
                      ? _titleController.text
                      : 'New Lab Assignment',
                  description: _descController.text,
                  dueDate: DateTime.now().add(const Duration(days: 7)),
                  maxScore: int.tryParse(_maxScoreController.text) ?? 100,
                  subject: course.category,
                  rubricCriteria: [
                    'Algorithmic Correctness (40%)',
                    'Efficiency and Benchmark (30%)',
                    'Code Quality (30%)',
                  ],
                ),
              );

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assignment created successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Create Assignment'),
          ),
        ],
      ),
    );
  }

  void _showGradeDialog(AssignmentSubmissionModel submission) {
    _gradeScoreController.text = (submission.score ?? 85.0).toString();
    _teacherFeedbackController.text =
        submission.teacherFeedback ?? 'Good submission with strong execution.';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Evaluate: ${submission.studentName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Submission Content / Repository:'),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  submission.submissionContent,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              if (submission.aiFeedback != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Recommendation Score: 90 / 100',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        submission.aiFeedback!,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _gradeScoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Final Score'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _teacherFeedbackController,
                maxLines: 2,
                decoration:
                    const InputDecoration(labelText: 'Instructor Feedback'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final asgService =
                  Provider.of<AssignmentService>(context, listen: false);
              asgService.gradeSubmission(
                submissionId: submission.id,
                score: double.tryParse(_gradeScoreController.text) ?? 85.0,
                teacherFeedback: _teacherFeedbackController.text,
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Grade and feedback saved!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save Evaluation'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asgService = Provider.of<AssignmentService>(context);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final assignments = asgService.assignments;
    final submissions = asgService.submissions;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(
                activeRoute: AppConstants.routeTeacherAssignments),

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Assignments & AI Grading Assistance',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Create coursework, inspect student submissions, and review AI pre-graded feedback.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _showCreateAssignmentDialog,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Create Assignment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
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
                    // Submissions Queue
                    const Text(
                      'Student Submissions Queue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: submissions.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: AppColors.divider),
                        itemBuilder: (context, index) {
                          final sub = submissions[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.1),
                              child: Text(
                                sub.studentName[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            title: Text(
                              sub.studentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              'Score: ${sub.score?.toStringAsFixed(1) ?? 'Pending'} pts • ${sub.aiFeedback ?? 'AI Analyzed'}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _showGradeDialog(sub),
                              child: const Text('Review & Grade'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Active Assignments List
                    const Text(
                      'Active Coursework Assignments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...assignments.map((asg) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            asg.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              '${asg.courseTitle} • Max Score: ${asg.maxScore} pts'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
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
}
