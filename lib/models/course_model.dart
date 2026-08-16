class CourseSyllabusItem {
  final int weekNumber;
  final String title;
  final String description;
  final List<String> topics;

  CourseSyllabusItem({
    required this.weekNumber,
    required this.title,
    required this.description,
    required this.topics,
  });

  factory CourseSyllabusItem.fromJson(Map<String, dynamic> json) {
    return CourseSyllabusItem(
      weekNumber: json['weekNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      topics: List<String>.from(json['topics'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekNumber': weekNumber,
      'title': title,
      'description': description,
      'topics': topics,
    };
  }
}

class CourseModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String category;
  final String teacherId;
  final String teacherName;
  final String? teacherTitle;
  final String? teacherAvatar;
  final int credits;
  final String schedule;
  final String room;
  final double rating;
  final int enrolledStudentCount;
  final List<CourseSyllabusItem> syllabus;
  final List<String> learningOutcomes;
  final bool isFeatured;

  CourseModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.category,
    required this.teacherId,
    required this.teacherName,
    this.teacherTitle,
    this.teacherAvatar,
    required this.credits,
    required this.schedule,
    required this.room,
    this.rating = 4.8,
    this.enrolledStudentCount = 0,
    this.syllabus = const [],
    this.learningOutcomes = const [],
    this.isFeatured = false,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      teacherId: json['teacherId'] as String,
      teacherName: json['teacherName'] as String,
      teacherTitle: json['teacherTitle'] as String?,
      teacherAvatar: json['teacherAvatar'] as String?,
      credits: json['credits'] as int? ?? 3,
      schedule: json['schedule'] as String,
      room: json['room'] as String? ?? 'Room 301',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      enrolledStudentCount: json['enrolledStudentCount'] as int? ?? 0,
      syllabus: (json['syllabus'] as List<dynamic>?)
              ?.map((e) => CourseSyllabusItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      learningOutcomes: List<String>.from(json['learningOutcomes'] ?? []),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'category': category,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'teacherTitle': teacherTitle,
      'teacherAvatar': teacherAvatar,
      'credits': credits,
      'schedule': schedule,
      'room': room,
      'rating': rating,
      'enrolledStudentCount': enrolledStudentCount,
      'syllabus': syllabus.map((e) => e.toJson()).toList(),
      'learningOutcomes': learningOutcomes,
      'isFeatured': isFeatured,
    };
  }

  CourseModel copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    String? category,
    String? teacherId,
    String? teacherName,
    String? teacherTitle,
    String? teacherAvatar,
    int? credits,
    String? schedule,
    String? room,
    double? rating,
    int? enrolledStudentCount,
    List<CourseSyllabusItem>? syllabus,
    List<String>? learningOutcomes,
    bool? isFeatured,
  }) {
    return CourseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      teacherTitle: teacherTitle ?? this.teacherTitle,
      teacherAvatar: teacherAvatar ?? this.teacherAvatar,
      credits: credits ?? this.credits,
      schedule: schedule ?? this.schedule,
      room: room ?? this.room,
      rating: rating ?? this.rating,
      enrolledStudentCount: enrolledStudentCount ?? this.enrolledStudentCount,
      syllabus: syllabus ?? this.syllabus,
      learningOutcomes: learningOutcomes ?? this.learningOutcomes,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
