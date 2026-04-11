import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.preferredLanguage,
    required this.unit,
  });

  final String userId;
  final String name;
  final String email;
  final DateTime createdAt;
  final String preferredLanguage;
  final String unit;

  factory UserModel.fromMap(String documentId, Map<String, dynamic> map) {
    final createdAtValue = map['createdAt'];

    return UserModel(
      userId: documentId,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.now(),
      preferredLanguage: map['preferredLanguage'] as String? ?? 'en_US',
      unit: map['unit'] as String? ?? 'meters',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'preferredLanguage': preferredLanguage,
      'unit': unit,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    DateTime? createdAt,
    String? preferredLanguage,
    String? unit,
  }) {
    return UserModel(
      userId: userId,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      unit: unit ?? this.unit,
    );
  }
}
