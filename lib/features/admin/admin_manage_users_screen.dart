import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/public_header.dart';

class AdminManageUsersScreen extends StatefulWidget {
  const AdminManageUsersScreen({super.key});

  @override
  State<AdminManageUsersScreen> createState() => _AdminManageUsersScreenState();
}

class _AdminManageUsersScreenState extends State<AdminManageUsersScreen> {
  final List<UserModel> _users = [
    MockData.demoStudent1,
    MockData.demoStudentAtRisk,
    MockData.demoStudentTop,
    MockData.demoTeacher1,
    MockData.demoTeacher2,
  ];

  UserRole _tabRole = UserRole.student;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _deptCtrl = TextEditingController(text: 'Computer Science');
  final _idCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _deptCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  void _showAddUserDialog() {
    _nameCtrl.clear();
    _emailCtrl.clear();
    _idCtrl.text = _tabRole == UserRole.student
        ? 'CS-2026-${DateTime.now().millisecond}'
        : 'FAC-${DateTime.now().millisecond}';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add New ${_tabRole.name.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deptCtrl,
              decoration: const InputDecoration(labelText: 'Department'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _idCtrl,
              decoration: InputDecoration(
                labelText: _tabRole == UserRole.student
                    ? 'Student ID Number'
                    : 'Faculty ID Number',
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
              if (_nameCtrl.text.isNotEmpty) {
                setState(() {
                  _users.add(UserModel(
                    id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
                    name: _nameCtrl.text,
                    email: _emailCtrl.text.isNotEmpty
                        ? _emailCtrl.text
                        : '${_nameCtrl.text.toLowerCase().replaceAll(' ', '.')}@edupulse.ai',
                    role: _tabRole,
                    department: _deptCtrl.text,
                    studentIdNumber:
                        _tabRole == UserRole.student ? _idCtrl.text : null,
                    teacherTitle: _tabRole == UserRole.teacher
                        ? 'Assistant Professor'
                        : null,
                  ));
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User ${_nameCtrl.text} added!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((u) => u.role == _tabRole).toList();
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeAdminUsers),

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
                          'Manage Students & Faculty Directory',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Create accounts, assign departmental affiliations, and update profiles.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddUserDialog,
                      icon: const Icon(Icons.person_add, size: 16),
                      label: Text('Add ${_tabRole.name.toUpperCase()}'),
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
                    // Role Tab Switcher
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Students Directory'),
                          selected: _tabRole == UserRole.student,
                          onSelected: (_) => setState(() {
                            _tabRole = UserRole.student;
                          }),
                          selectedColor: AppColors.primaryDark,
                          labelStyle: TextStyle(
                            color: _tabRole == UserRole.student
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text('Faculty & Teachers Directory'),
                          selected: _tabRole == UserRole.teacher,
                          onSelected: (_) => setState(() {
                            _tabRole = UserRole.teacher;
                          }),
                          selectedColor: AppColors.primaryDark,
                          labelStyle: TextStyle(
                            color: _tabRole == UserRole.teacher
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // User List
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredUsers.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: AppColors.divider),
                        itemBuilder: (context, index) {
                          final u = filteredUsers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  AppColors.primaryDark.withOpacity(0.08),
                              child: Text(
                                u.name[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                            title: Text(
                              u.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              '${u.email} • Department: ${u.department ?? 'General'} • ID: ${u.studentIdNumber ?? u.teacherTitle ?? 'Active'}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.error),
                              onPressed: () {
                                setState(() {
                                  _users.remove(u);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed ${u.name}'),
                                  ),
                                );
                              },
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
}
