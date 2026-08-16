import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/mock_data.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  UserRole get currentRole => _currentUser?.role ?? UserRole.student;

  AuthService() {
    // Default initial user for instant demo accessibility
    _currentUser = MockData.demoStudent1;
  }

  // Quick Demo Login Switcher for Judges / Evaluators
  void loginAsStudent({bool isAtRisk = false}) {
    _currentUser = isAtRisk ? MockData.demoStudentAtRisk : MockData.demoStudent1;
    _errorMessage = null;
    notifyListeners();
  }

  void loginAsTeacher() {
    _currentUser = MockData.demoTeacher1;
    _errorMessage = null;
    notifyListeners();
  }

  void loginAsAdmin() {
    _currentUser = MockData.demoAdmin;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password, UserRole role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400)); // Simulate async

    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail == MockData.demoAdmin.email.toLowerCase() || role == UserRole.admin) {
      _currentUser = MockData.demoAdmin;
    } else if (cleanEmail == MockData.demoTeacher1.email.toLowerCase() || role == UserRole.teacher) {
      _currentUser = MockData.demoTeacher1;
    } else if (cleanEmail == MockData.demoStudentAtRisk.email.toLowerCase()) {
      _currentUser = MockData.demoStudentAtRisk;
    } else {
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        email: cleanEmail.isNotEmpty ? cleanEmail : 'user@edupulse.ai',
        name: cleanEmail.isNotEmpty ? cleanEmail.split('@').first.toUpperCase() : 'Student User',
        role: role,
        department: 'Computer Science',
        studentIdNumber: role == UserRole.student ? 'STD-${DateTime.now().millisecond}' : null,
        enrolledCourseIds: ['crs_001', 'crs_002'],
      );
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? department,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email.trim().toLowerCase(),
      role: role,
      department: department ?? 'General Studies',
      studentIdNumber: role == UserRole.student ? 'ID-${DateTime.now().millisecond}' : null,
      enrolledCourseIds: ['crs_001'],
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateProfile({String? name, String? department, String? avatarUrl}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      department: department,
      avatarUrl: avatarUrl,
    );
    notifyListeners();
  }
}
