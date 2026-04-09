import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSessionModel {
  const TrainingSessionModel({
    required this.sessionId,
    required this.userId,
    required this.date,
    required this.totalArrows,
    required this.averageScore,
    required this.xCount,
    required this.tenCount,
    required this.createdAt,
    this.name = '',
    this.isSpotter = false,
  });

  final String sessionId;
  final String userId;
  final String name;
  final DateTime date;
  final int totalArrows;
  final double averageScore;
  final int xCount;
  final int tenCount;
  final DateTime createdAt;
  final bool isSpotter;

  factory TrainingSessionModel.fromMap(
    String documentId,
    Map<String, dynamic> map,
  ) {
    return TrainingSessionModel(
      sessionId: documentId,
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalArrows: map['totalArrows'] as int? ?? 0,
      averageScore: (map['averageScore'] as num?)?.toDouble() ?? 0,
      xCount: map['xCount'] as int? ?? 0,
      tenCount: map['tenCount'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSpotter: map['isSpotter'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'date': Timestamp.fromDate(date),
      'totalArrows': totalArrows,
      'averageScore': averageScore,
      'xCount': xCount,
      'tenCount': tenCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'isSpotter': isSpotter,
    };
  }

  TrainingSessionModel copyWith({
    String? name,
    int? totalArrows,
    double? averageScore,
    int? xCount,
    int? tenCount,
    bool? isSpotter,
  }) {
    return TrainingSessionModel(
      sessionId: sessionId,
      userId: userId,
      name: name ?? this.name,
      date: date,
      totalArrows: totalArrows ?? this.totalArrows,
      averageScore: averageScore ?? this.averageScore,
      xCount: xCount ?? this.xCount,
      tenCount: tenCount ?? this.tenCount,
      createdAt: createdAt,
      isSpotter: isSpotter ?? this.isSpotter,
    );
  }
}