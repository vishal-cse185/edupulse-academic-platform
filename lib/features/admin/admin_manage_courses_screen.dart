import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/course_model.dart';
import '../../services/course_service.dart';
import '../../widgets/public_header.dart';

class AdminManageCoursesScreen extends StatefulWidget {
  const AdminManageCoursesScreen({super.key});

  @override
  State<AdminManageCoursesScreen> createState() =>
      _AdminManageCoursesScreenState();
}

class _AdminManageCoursesScreenState extends State<AdminManageCoursesScreen> {
  final _titleCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _creditsCtrl = TextEditingController(text: '4');
  final _roomCtrl = TextEditingController(text: 'Hall 302');
  final _scheduleCtrl =
      TextEditingController(text: 'Mon, Wed (10:00 AM - 11:30 AM)');
  String _category = 'Computer Science';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _creditsCtrl.dispose();
    _roomCtrl.dispose();
    _scheduleCtrl.dispose();
    super.dispose();
  }

  void _showAddCourseDialog() {
    _titleCtrl.clear();
    _codeCtrl.clear();
    _descCtrl.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Academic Course'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                    labelText: 'Course Code (e.g. CS405)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Course Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _creditsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Credits'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _scheduleCtrl,
                decoration: const InputDecoration(labelText: 'Schedule'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _roomCtrl,
                decoration: const InputDecoration(labelText: 'Lecture Room'),
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
              if (_titleCtrl.text.isNotEmpty && _codeCtrl.text.isNotEmpty) {
                final courseService =
                    Provider.of<CourseService>(context, listen: false);

                courseService.addCourse(
                  CourseModel(
                    id: 'crs_${DateTime.now().millisecondsSinceEpoch}',
                    code: _codeCtrl.text.toUpperCase(),
                    title: _titleCtrl.text,
                    description: _descCtrl.text,
                    category: _category,
                    teacherId: 'tch_001',
                    teacherName: 'Dr. Alan Turing',
                    teacherTitle: 'Professor of Computing',
                    credits: int.tryParse(_creditsCtrl.text) ?? 4,
                    schedule: _scheduleCtrl.text,
                    room: _roomCtrl.text,
                    isFeatured: true,
                    learningOutcomes: [
                      'Formulate rigorous algorithmic solutions',
                      'Design modular systems',
                    ],
                    syllabus: [
                      CourseSyllabusItem(
                        weekNumber: 1,
                        title: 'Foundations & Architecture',
                        description: 'Introductory concepts and setup.',
                        topics: ['Basics', 'Design Principles'],
                      ),
                    ],
                  ),
                );

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Course ${_codeCtrl.text} added!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Save Course'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseService = Provider.of<CourseService>(context);
    final courses = courseService.courses;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeAdminCourses),

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
                          'Manage Curriculum & Course Catalog',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Configure courses, assign faculty instructors, manage schedules and syllabi.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddCourseDialog,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add New Course'),
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
                    const Text(
                      'All Active Courses & Curriculum Offerings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...courses.map((c) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryDark
                                              .withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          c.code,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        c.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Faculty: ${c.teacherName} • ${c.credits} Credits • ${c.schedule} (${c.room})',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColors.error),
                                onPressed: () {
                                  courseService.deleteCourse(c.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Deleted ${c.code}')),
                                  );
                                },
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
