import '../core/constants.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? avatarUrl;
  final String? department;
  final String? studentIdNumber;
  final String? teacherTitle;
  final List<String> enrolledCourseIds;
  final List<String> teachingCourseIds;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.department,
    this.studentIdNumber,
    this.teacherTitle,
    this.enrolledCourseIds = const [],
    this.teachingCourseIds = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.student,
      ),
      avatarUrl: json['avatarUrl'] as String?,
      department: json['department'] as String?,
      studentIdNumber: json['studentIdNumber'] as String?,
      teacherTitle: json['teacherTitle'] as String?,
      enrolledCourseIds: List<String>.from(json['enrolledCourseIds'] ?? []),
      teachingCourseIds: List<String>.from(json['teachingCourseIds'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'department': department,
      'studentIdNumber': studentIdNumber,
      'teacherTitle': teacherTitle,
      'enrolledCourseIds': enrolledCourseIds,
      'teachingCourseIds': teachingCourseIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? avatarUrl,
    String? department,
    String? studentIdNumber,
    String? teacherTitle,
    List<String>? enrolledCourseIds,
    List<String>? teachingCourseIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      department: department ?? this.department,
      studentIdNumber: studentIdNumber ?? this.studentIdNumber,
      teacherTitle: teacherTitle ?? this.teacherTitle,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      teachingCourseIds: teachingCourseIds ?? this.teachingCourseIds,
      createdAt: createdAt,
    );
  }
}
