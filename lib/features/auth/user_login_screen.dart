import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class UserLoginScreen extends StatefulWidget {
  final UserRole initialRole;

  const UserLoginScreen({super.key, this.initialRole = UserRole.student});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  late UserRole _selectedRole;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _syncDemoCredentials();
  }

  void _syncDemoCredentials() {
    if (_selectedRole == UserRole.student) {
      _emailController.text = 'student@edupulse.ai';
      _passwordController.text = 'password123';
    } else if (_selectedRole == UserRole.teacher) {
      _emailController.text = 'teacher@edupulse.ai';
      _passwordController.text = 'password123';
    } else {
      _emailController.text = 'admin@edupulse.ai';
      _passwordController.text = 'admin123';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final auth = Provider.of<AuthService>(context, listen: false);

    if (_isSignUp) {
      final success = await auth.register(
        name: _nameController.text.isNotEmpty
            ? _nameController.text
            : 'New ${_selectedRole.name.toUpperCase()}',
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        department: _departmentController.text,
      );
      if (success && mounted) _navigateToDashboard(_selectedRole);
    } else {
      final success = await auth.login(
        _emailController.text,
        _passwordController.text,
        _selectedRole,
      );
      if (success && mounted) _navigateToDashboard(_selectedRole);
    }
  }

  void _navigateToDashboard(UserRole role) {
    switch (role) {
      case UserRole.student:
        Navigator.pushReplacementNamed(
            context, AppConstants.routeStudentDashboard);
        break;
      case UserRole.teacher:
        Navigator.pushReplacementNamed(
            context, AppConstants.routeTeacherDashboard);
        break;
      case UserRole.admin:
        Navigator.pushReplacementNamed(
            context, AppConstants.routeAdminDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & Heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.school_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'EduPulse AI',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isSignUp
                        ? 'Create New Account'
                        : 'Sign In to Your Workspace',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Select your institutional role to continue',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Role Selection Segmented Buttons
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildRoleTab('Student', UserRole.student),
                        _buildRoleTab('Teacher', UserRole.teacher),
                        _buildRoleTab('Admin', UserRole.admin),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // AI Evaluation Quick-Login Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.bolt, size: 16, color: AppColors.accent),
                            SizedBox(width: 4),
                            Text(
                              'Instant 1-Click Evaluation Presets:',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildPresetChip(
                              label: '👨‍🎓 Alex (Normal)',
                              onTap: () {
                                auth.loginAsStudent(isAtRisk: false);
                                _navigateToDashboard(UserRole.student);
                              },
                            ),
                            _buildPresetChip(
                              label: '⚠️ David (At-Risk <75%)',
                              onTap: () {
                                auth.loginAsStudent(isAtRisk: true);
                                _navigateToDashboard(UserRole.student);
                              },
                            ),
                            _buildPresetChip(
                              label: '👩‍🏫 Dr. Turing (Teacher)',
                              onTap: () {
                                auth.loginAsTeacher();
                                _navigateToDashboard(UserRole.teacher);
                              },
                            ),
                            _buildPresetChip(
                              label: '🛡️ Dean Eleanor (Admin)',
                              onTap: () {
                                auth.loginAsAdmin();
                                _navigateToDashboard(UserRole.admin);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Fields
                  if (_isSignUp) ...[
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _departmentController,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Institutional Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: auth.isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isSignUp ? 'Create Account' : 'Sign In'),
                  ),
                  const SizedBox(height: 16),

                  // Toggle Sign In / Sign Up
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Text(
                      _isSignUp
                          ? 'Already have an account? Sign In'
                          : "Don't have an account? Sign Up",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),

                  // Back to Public Portal
                  TextButton.icon(
                    onPressed: () => Navigator.pushNamed(
                        context, AppConstants.routeHome),
                    icon: const Icon(Icons.arrow_back, size: 14),
                    label: const Text('Back to Public Home',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(String label, UserRole role) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRole = role;
            _syncDemoCredentials();
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFC7D2FE)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}
