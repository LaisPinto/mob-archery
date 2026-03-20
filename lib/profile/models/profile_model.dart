import 'package:mob_archery/auth/models/user_model.dart';

class ProfileModel {
  const ProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.preferredLanguage,
    required this.unit,
  });

  final String userId;
  final String name;
  final String email;
  final String preferredLanguage;
  final String unit;

  factory ProfileModel.fromUserModel(UserModel userModel) {
    return ProfileModel(
      userId: userModel.userId,
      name: userModel.name,
      email: userModel.email,
      preferredLanguage: userModel.preferredLanguage,
      unit: userModel.unit,
    );
  }
}
