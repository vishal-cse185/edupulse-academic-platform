import '../core/constants.dart';

class WeakSubjectDetail {
  final String subjectName;
  final double averageScore;
  final int missedAssignments;
  final double attendancePercentage;
  final List<String> conceptGaps;
  final String suggestedRemedy;

  WeakSubjectDetail({
    required this.subjectName,
    required this.averageScore,
    this.missedAssignments = 0,
    required this.attendancePercentage,
    this.conceptGaps = const [],
    required this.suggestedRemedy,
  });

  factory WeakSubjectDetail.fromJson(Map<String, dynamic> json) {
    return WeakSubjectDetail(
      subjectName: json['subjectName'] as String,
      averageScore: (json['averageScore'] as num).toDouble(),
      missedAssignments: json['missedAssignments'] as int? ?? 0,
      attendancePercentage: (json['attendancePercentage'] as num).toDouble(),
      conceptGaps: List<String>.from(json['conceptGaps'] ?? []),
      suggestedRemedy: json['suggestedRemedy'] as String? ?? 'Review basics',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'averageScore': averageScore,
      'missedAssignments': missedAssignments,
      'attendancePercentage': attendancePercentage,
      'conceptGaps': conceptGaps,
      'suggestedRemedy': suggestedRemedy,
    };
  }
}

class StudyRecommendation {
  final String id;
  final String subject;
  final String title;
  final String description;
  final String actionType; // 'Review', 'Practice', 'Office Hours', 'Revision'
  final String priority; // 'High', 'Medium', 'Low'
  final int estimatedMinutes;
  final bool isCompleted;

  StudyRecommendation({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
    required this.actionType,
    this.priority = 'Medium',
    this.estimatedMinutes = 30,
    this.isCompleted = false,
  });

  factory StudyRecommendation.fromJson(Map<String, dynamic> json) {
    return StudyRecommendation(
      id: json['id'] as String,
      subject: json['subject'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      actionType: json['actionType'] as String? ?? 'Review',
      priority: json['priority'] as String? ?? 'Medium',
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 30,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'title': title,
      'description': description,
      'actionType': actionType,
      'priority': priority,
      'estimatedMinutes': estimatedMinutes,
      'isCompleted': isCompleted,
    };
  }

  StudyRecommendation copyWith({
    String? id,
    String? subject,
    String? title,
    String? description,
    String? actionType,
    String? priority,
    int? estimatedMinutes,
    bool? isCompleted,
  }) {
    return StudyRecommendation(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      description: description ?? this.description,
      actionType: actionType ?? this.actionType,
      priority: priority ?? this.priority,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class AIInsightModel {
  final String studentId;
  final String studentName;
  final double overallScore;
  final double attendanceRate;
  final RiskLevel riskLevel;
  final String trend; // 'improving', 'stable', 'declining'
  final List<WeakSubjectDetail> weakSubjects;
  final List<String> riskFactors;
  final List<StudyRecommendation> recommendations;
  final String executiveSummary;
  final DateTime generatedAt;

  AIInsightModel({
    required this.studentId,
    required this.studentName,
    required this.overallScore,
    required this.attendanceRate,
    required this.riskLevel,
    required this.trend,
    this.weakSubjects = const [],
    this.riskFactors = const [],
    this.recommendations = const [],
    required this.executiveSummary,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  factory AIInsightModel.fromJson(Map<String, dynamic> json) {
    return AIInsightModel(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      overallScore: (json['overallScore'] as num).toDouble(),
      attendanceRate: (json['attendanceRate'] as num).toDouble(),
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.name == json['riskLevel'],
        orElse: () => RiskLevel.low,
      ),
      trend: json['trend'] as String? ?? 'stable',
      weakSubjects: (json['weakSubjects'] as List<dynamic>?)
              ?.map((e) => WeakSubjectDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      riskFactors: List<String>.from(json['riskFactors'] ?? []),
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => StudyRecommendation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      executiveSummary: json['executiveSummary'] as String? ?? '',
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'overallScore': overallScore,
      'attendanceRate': attendanceRate,
      'riskLevel': riskLevel.name,
      'trend': trend,
      'weakSubjects': weakSubjects.map((e) => e.toJson()).toList(),
      'riskFactors': riskFactors,
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
      'executiveSummary': executiveSummary,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}
