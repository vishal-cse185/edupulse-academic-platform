import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/database_service.dart';
import '../models/note_model.dart';

class DesktopNotesService extends ChangeNotifier {
  final DatabaseService? _dbService;
  List<NoteModel> _notes = [];
  bool _isLoading = false;

  DesktopNotesService([this._dbService]);

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> addNote(String studentId, String content) async {
    if (_dbService == null) return;

    try {
      await _dbService.createNote(studentId, content);
      // Refresh notes after adding
      // await loadNotes(studentId);
    } catch (e) {
      debugPrint("Error adding note: $e");
    }
  }

  Future<void> loadNotes(String studentId) async {
    if (_dbService == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _dbService.getStudentNotes(studentId).first;
      _notes =
          snapshot.map((data) {
            // Manually map since we are getting Map<String, dynamic> from the stream in DatabaseService
            // Ideally DatabaseService should return NoteModel, but we kept it simple there.
            // Actually, let's use the NoteModel.fromFirestore if we had a DocumentSnapshot,
            // but here we have a Map. Let's adjust NoteModel or just map manually.
            return NoteModel(
              id: data['id'] ?? '',
              studentId: data['studentId'] ?? '',
              content: data['content'] ?? '',
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            );
          }).toList();
    } catch (e) {
      debugPrint("Error loading notes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
