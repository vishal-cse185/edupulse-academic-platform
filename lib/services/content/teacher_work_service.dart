import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/content_model.dart';

class TeacherWorkService extends ChangeNotifier {
  List<ContentModel> _assignments = [];
  bool _isLoading = false;

  List<ContentModel> get assignments => _assignments;
  bool get isLoading => _isLoading;

  // Mock data for demonstration
  final String _mockJson = '''
  [
    {
      "id": "1",
      "title": "History Chapter 4",
      "description": "Read the chapter about the Industrial Revolution.",
      "type": "reading",
      "dueDate": "2025-12-10T10:00:00.000"
    },
    {
      "id": "2",
      "title": "Math Homework",
      "description": "Complete exercises 5 to 10 on page 42.",
      "type": "assignment",
      "dueDate": "2025-12-11T14:00:00.000"
    },
    {
      "id": "3",
      "title": "Science Quiz",
      "description": "Prepare for the quiz on Photosynthesis.",
      "type": "quiz",
      "dueDate": "2025-12-12T09:00:00.000"
    }
  ]
  ''';

  Future<void> loadAssignments() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      final List<dynamic> data = json.decode(_mockJson);
      _assignments = data.map((e) => ContentModel.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading assignments: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ContentModel? getAssignmentById(String id) {
    try {
      return _assignments.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ContentModel> getTodaysWork() {
    final now = DateTime.now();
    return _assignments
        .where(
          (a) =>
              a.dueDate.year == now.year &&
              a.dueDate.month == now.month &&
              a.dueDate.day == now.day,
        )
        .toList();
  }
}
