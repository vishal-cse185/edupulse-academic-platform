import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String studentId;
  final String content;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.studentId,
    required this.content,
    required this.createdAt,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
