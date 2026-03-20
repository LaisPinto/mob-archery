import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingEndModel {
  const TrainingEndModel({
    required this.endId,
    required this.sessionId,
    required this.userId,
    required this.arrows,
    required this.averageScore,
    required this.xCount,
    required this.tenCount,
    required this.distance,
    required this.bowType,
    required this.registeredBy,
    required this.spotterName,
    required this.createdAt,
  });

  final String endId;
  final String sessionId;
  final String userId;
  final List<String> arrows;
  final double averageScore;
  final int xCount;
  final int tenCount;
  final double distance;
  final String bowType;
  final String registeredBy;
  final String? spotterName;
  final DateTime createdAt;

  factory TrainingEndModel.fromMap(String documentId, Map<String, dynamic> map) {
    return TrainingEndModel(
      endId: documentId,
      sessionId: map['sessionId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      arrows: (map['arrows'] as List<dynamic>? ?? []).cast<String>(),
      averageScore: (map['averageScore'] as num?)?.toDouble() ?? 0,
      xCount: map['xCount'] as int? ?? 0,
      tenCount: map['tenCount'] as int? ?? 0,
      distance: (map['distance'] as num?)?.toDouble() ?? 0,
      bowType: map['bowType'] as String? ?? '',
      registeredBy: map['registeredBy'] as String? ?? '',
      spotterName: map['spotterName'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'arrows': arrows,
      'averageScore': averageScore,
      'xCount': xCount,
      'tenCount': tenCount,
      'distance': distance,
      'bowType': bowType,
      'registeredBy': registeredBy,
      'spotterName': spotterName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
