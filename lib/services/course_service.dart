import 'package:flutter/material.dart';
import '../core/mock_data.dart';
import '../models/course_model.dart';

class CourseService extends ChangeNotifier {
  List<CourseModel> _courses = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<CourseModel> get courses => _courses;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  CourseService() {
    _courses = List.from(MockData.initialCourses);
  }

  List<CourseModel> get featuredCourses =>
      _courses.where((c) => c.isFeatured).toList();

  List<CourseModel> get filteredCourses {
    return _courses.where((course) {
      final matchesCategory = _selectedCategory == 'All' ||
          course.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.teacherName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  CourseModel? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<CourseModel> getCoursesForStudent(List<String> enrolledIds) {
    return _courses.where((c) => enrolledIds.contains(c.id)).toList();
  }

  List<CourseModel> getCoursesForTeacher(String teacherId) {
    return _courses.where((c) => c.teacherId == teacherId).toList();
  }

  bool enrollStudent(String courseId) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      final course = _courses[index];
      _courses[index] = course.copyWith(
        enrolledStudentCount: course.enrolledStudentCount + 1,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void addCourse(CourseModel course) {
    _courses.add(course);
    notifyListeners();
  }

  void updateCourse(CourseModel course) {
    final index = _courses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      _courses[index] = course;
      notifyListeners();
    }
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((c) => c.id == courseId);
    notifyListeners();
  }
}
