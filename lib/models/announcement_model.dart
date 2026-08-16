class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String category; // 'Exam', 'General', 'Academic', 'Event'
  final DateTime date;
  final String author;
  final bool isUrgent;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    required this.author,
    this.isUrgent = false,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String? ?? 'General',
      date: DateTime.parse(json['date'] as String),
      author: json['author'] as String? ?? 'Admin',
      isUrgent: json['isUrgent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'date': date.toIso8601String(),
      'author': author,
      'isUrgent': isUrgent,
    };
  }
}

class ContactInquiryModel {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final DateTime submittedAt;
  final String status; // 'New', 'In Review', 'Resolved'

  ContactInquiryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    DateTime? submittedAt,
    this.status = 'New',
  }) : submittedAt = submittedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'submittedAt': submittedAt.toIso8601String(),
      'status': status,
    };
  }
}

class FAQItemModel {
  final String question;
  final String answer;
  final String category;

  FAQItemModel({
    required this.question,
    required this.answer,
    this.category = 'General',
  });
}
