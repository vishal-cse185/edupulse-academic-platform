import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';
import '../../services/course_service.dart';
import '../../widgets/public_header.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  String _selectedCourseId = 'crs_001';
  final Map<String, AttendanceStatus> _rosterStatus = {
    'std_001': AttendanceStatus.present, // Alex Johnson
    'std_002': AttendanceStatus.absent, // David Smith
    'std_003': AttendanceStatus.present, // Sarah Connor
  };

  final List<Map<String, String>> _mockStudents = [
    {'id': 'std_001', 'name': 'Alex Johnson', 'roll': 'CS-2026-042'},
    {'id': 'std_002', 'name': 'David Smith (At Risk)', 'roll': 'CS-2026-088'},
    {'id': 'std_003', 'name': 'Sarah Connor', 'roll': 'AI-2026-015'},
  ];

  void _markAllPresent() {
    setState(() {
      for (final s in _mockStudents) {
        _rosterStatus[s['id']!] = AttendanceStatus.present;
      }
    });
  }

  void _saveAttendance() {
    final attService = Provider.of<AttendanceService>(context, listen: false);
    final courseService = Provider.of<CourseService>(context, listen: false);
    final course = courseService.getCourseById(_selectedCourseId) ??
        MockData.initialCourses.first;

    final records = _mockStudents.map((s) {
      return AttendanceRecord(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}_${s['id']}',
        studentId: s['id']!,
        studentName: s['name']!,
        courseId: course.id,
        courseCode: course.code,
        courseTitle: course.title,
        date: DateTime.now(),
        status: _rosterStatus[s['id']] ?? AttendanceStatus.present,
      );
    }).toList();

    attService.markBulkAttendance(records);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Attendance recorded for ${course.code} (${_mockStudents.length} students)!'),
        backgroundColor: AppColors.success,
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
            const PublicHeader(
                activeRoute: AppConstants.routeTeacherAttendance),

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
                          'Record Class Attendance',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Mark daily lecture attendance and synchronize student compliance metrics.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _saveAttendance,
                      icon: const Icon(Icons.save, size: 16),
                      label: const Text('Save Ledger'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
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
                    // Course Selector & Fast Actions
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Select Course Section: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              DropdownButton<String>(
                                value: _selectedCourseId,
                                underline: const SizedBox(),
                                items: courses.map((c) {
                                  return DropdownMenuItem(
                                    value: c.id,
                                    child: Text('${c.code}: ${c.title}'),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCourseId = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            onPressed: _markAllPresent,
                            icon: const Icon(Icons.done_all, size: 16),
                            label: const Text('Mark All Present'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Student Roster
                    const Text(
                      'Class Student Roster',
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
                        itemCount: _mockStudents.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: AppColors.divider),
                        itemBuilder: (context, index) {
                          final student = _mockStudents[index];
                          final currentStatus =
                              _rosterStatus[student['id']] ??
                                  AttendanceStatus.present;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: AppColors.primary
                                          .withOpacity(0.08),
                                      child: Text(
                                        student['name']![0],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student['name']!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Roll No: ${student['roll']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Status Selector Chips
                                Row(
                                  children: [
                                    _buildStatusChip(
                                      label: 'Present',
                                      isSelected: currentStatus ==
                                          AttendanceStatus.present,
                                      color: AppColors.success,
                                      onTap: () {
                                        setState(() {
                                          _rosterStatus[student['id']!] =
                                              AttendanceStatus.present;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatusChip(
                                      label: 'Late',
                                      isSelected: currentStatus ==
                                          AttendanceStatus.late,
                                      color: const Color(0xFFF59E0B),
                                      onTap: () {
                                        setState(() {
                                          _rosterStatus[student['id']!] =
                                              AttendanceStatus.late;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatusChip(
                                      label: 'Absent',
                                      isSelected: currentStatus ==
                                          AttendanceStatus.absent,
                                      color: AppColors.error,
                                      onTap: () {
                                        setState(() {
                                          _rosterStatus[student['id']!] =
                                              AttendanceStatus.absent;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(isSelected ? 1.0 : 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
