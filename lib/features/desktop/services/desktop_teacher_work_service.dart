import 'package:flutter/foundation.dart';
import '../../../services/database_service.dart';
import '../models/desktop_content_model.dart';

class DesktopTeacherWorkService extends ChangeNotifier {
  final DatabaseService? _dbService;
  List<DesktopContentModel> _assignments = [];
  bool _isLoading = false;

  DesktopTeacherWorkService([this._dbService]);

  List<DesktopContentModel> get assignments => _assignments;
  bool get isLoading => _isLoading;

  Future<void> loadAssignments(String studentId) async {
    if (_dbService == null) {
      debugPrint(
        "DatabaseService not initialized in DesktopTeacherWorkService",
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Fetch real assignments from Firestore
      // We take the first snapshot to get current data
      final snapshot = await _dbService.getStudentAssignments(studentId).first;

      _assignments =
          snapshot.map((assignment) {
            return DesktopContentModel(
              id: assignment.assignmentId,
              title: assignment.title,
              description: assignment.description,
              dueDate:
                  assignment.dueDate ??
                  DateTime.now().add(const Duration(days: 7)),
            );
          }).toList();
    } catch (e) {
      debugPrint("Error loading desktop assignments: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
