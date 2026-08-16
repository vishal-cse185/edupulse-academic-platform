import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/exam_model.dart';
import '../../services/exam_service.dart';
import '../../services/course_service.dart';
import '../../widgets/public_header.dart';

class TeacherExamsScreen extends StatefulWidget {
  const TeacherExamsScreen({super.key});

  @override
  State<TeacherExamsScreen> createState() => _TeacherExamsScreenState();
}

class _TeacherExamsScreenState extends State<TeacherExamsScreen> {
  final _marksController = TextEditingController();
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _marksController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _showEnterMarksDialog(ExamModel exam, String studentId, String studentName) {
    _marksController.text = '85.0';
    _feedbackController.text = 'Demonstrated clear conceptual grasp of key theorems.';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enter Marks: $studentName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exam: ${exam.title} (${exam.totalMarks} Total Marks)'),
            const SizedBox(height: 14),
            TextField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Marks Obtained',
                prefixIcon: Icon(Icons.grade_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feedbackController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Teacher Remarks / Diagnostic Feedback',
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
            onPressed: () {
              final examService =
                  Provider.of<ExamService>(context, listen: false);
              final score = double.tryParse(_marksController.text) ?? 85.0;

              examService.recordGrade(
                ExamGradeModel(
                  id: 'grd_${DateTime.now().millisecondsSinceEpoch}',
                  examId: exam.id,
                  examTitle: exam.title,
                  studentId: studentId,
                  studentName: studentName,
                  courseId: exam.courseId,
                  courseTitle: exam.courseTitle,
                  subject: 'Data Structures',
                  marksObtained: score,
                  totalMarks: exam.totalMarks.toDouble(),
                  remarks: _feedbackController.text,
                ),
              );

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exam marks and feedback recorded!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save Marks'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final examService = Provider.of<ExamService>(context);
    final courseService = Provider.of<CourseService>(context);
    final exams = examService.exams;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeTeacherExams),

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
                      'Examinations, Marks & Grading Matrix',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Conduct examinations, record scores, and track class grade distributions.',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Scheduled & Completed Examinations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showScheduleExamDialog(context);
                          },
                          icon: const Icon(Icons.add_task, size: 16),
                          label: const Text('Schedule New Exam'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...exams.map((exam) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 20),
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
                                    exam.title,
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
                                      color: AppColors.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${exam.totalMarks} Total Marks',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${exam.courseTitle} • ${exam.durationMinutes} mins • Venue: ${exam.room}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Divider(
                                  height: 24, color: AppColors.divider),

                              const Text(
                                'Class Marks Entry:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _showEnterMarksDialog(
                                        exam, 'std_001', 'Alex Johnson'),
                                    icon: const Icon(Icons.edit, size: 14),
                                    label: const Text('Alex Johnson (88/100)'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () => _showEnterMarksDialog(
                                        exam, 'std_002', 'David Smith (At Risk)'),
                                    icon: const Icon(Icons.edit, size: 14),
                                    label: const Text(
                                        'David Smith (46/100) ⚠️'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () => _showEnterMarksDialog(
                                        exam, 'std_003', 'Sarah Connor'),
                                    icon: const Icon(Icons.edit, size: 14),
                                    label: const Text('Sarah Connor (96/100)'),
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

  void _showScheduleExamDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final courseCtrl = TextEditingController(text: 'CS301 - Data Structures & Algorithms');
    final totalMarksCtrl = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.add_task, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text('Schedule New Examination'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Exam Title',
                hintText: 'e.g. Endterm Practical Assessment',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: courseCtrl,
              decoration: const InputDecoration(
                labelText: 'Course Offering',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: totalMarksCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Maximum Total Marks',
                border: OutlineInputBorder(),
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
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                final examService = Provider.of<ExamService>(context, listen: false);
                examService.addExam(ExamModel(
                  id: 'ex_${DateTime.now().millisecondsSinceEpoch}',
                  courseId: 'crs_001',
                  courseTitle: courseCtrl.text,
                  title: titleCtrl.text,
                  examDate: DateTime.now().add(const Duration(days: 14)),
                  durationMinutes: 120,
                  totalMarks: int.tryParse(totalMarksCtrl.text) ?? 100,
                  weightagePercentage: 30.0,
                  room: 'Hall 402',
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Examination "${titleCtrl.text}" scheduled successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Schedule Exam'),
          ),
        ],
      ),
    );
  }
}
